//
//  zdcViewController.m
//  AirTrack
//
//  Created by Keiichiro Nagashima on 2014/06/18.
//  Copyright (c) 2014年 Keiichiro Nagashima. All rights reserved.
//

#import "zdcViewController.h"
#import "AppDelegate.h"

#import <AdSupport/AdSupport.h>
#import <MapKit/MapKit.h>


#import "LocationManager.h"
#import "GeoFenceManager.h"
#import "GFaCommon.h"

#define FENCE_1 100.0
#define FENCE_2 500.0
#define FENCE_3 1000.0


@interface zdcViewController ()<LocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (nonatomic) GeoFenceManager *geoFenceManager;

@property (nonatomic) BOOL setObserver;
@property (nonatomic) NSUInteger times;
@property (nonatomic) NSDictionary *settings;
@property (nonatomic) NSString *idfa;
@end

@implementation zdcViewController{
    BOOL _isMonitoring;

	CLLocationCoordinate2D _centerLocation;
    CLCircularRegion *_regionNearby;
}

- (void)showDialog:(NSString *)str
{
    return;

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.delegate       = self;
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

- (NSString *)locationLogFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask,
														 YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd"];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	NSString *dateStr = [formatter stringFromDate:[NSDate date]];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LocationSample_%@.txt", dateStr]];
	
	return path;
}

- (void)createLocationLogFile:(NSString *)filePath
{
	NSFileManager *manager = [NSFileManager defaultManager];
	if ( [manager fileExistsAtPath:filePath] == YES )
	{
	}
	else
	{
		[manager createFileAtPath:filePath contents:nil attributes:nil];
	}
}

- (void)saveLogFile:(NSString *)logString
{
	NSString *filePath = [self locationLogFilePath];
	if ( filePath != nil )
	{
		[self createLocationLogFile:filePath];
        
		NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
		[fileHandle seekToEndOfFile];
		
		NSData *data = [logString dataUsingEncoding:NSUTF8StringEncoding];
		[fileHandle writeData:data];
		[fileHandle closeFile];
	}
}

- (NSString *)createLogData:(LocationInfo *)locationInfo
{
	NSMutableString *log = nil;
	if ( locationInfo != nil )
	{
		
		/* 出力ログの形成 */
		log = [NSMutableString string];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
		NSDate *timeStamp = locationInfo.timeStamp;
		[log appendString:[formatter stringFromDate:timeStamp]];
		[log appendString:@",gps,"];
        
		[log appendFormat:@"%f", locationInfo.latitude];
		[log appendString:@","];
		[log appendFormat:@"%f", locationInfo.longitude];
		[log appendString:@"\n"];
	}
    
	return log;
}

- (NSString *)createStatusLogData:(MeasuringType)measureStatus reason:(MeasuringTypeChangeReason)reason
{
	NSMutableString *log = [NSMutableString string];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
	NSString *dateStr = [formatter stringFromDate:[NSDate date]];
	[log appendString:dateStr];
	[log appendString:@","];
    
	BOOL flag = YES;
	if ( measureStatus == MeasuringType_Significant )
	{
		flag = NO;
	}
	
	[log appendString:@"測位方法変更通知: "];
	if ( reason == MeasuringTypeChange_Battery )
	{
		if ( flag == YES )
		{
			[log appendString:@"バッテリ残量復帰により標準測位に変更"];
		}
		else
		{
			[log appendString:@"バッテリ残量低下により基地局測位に変更"];
		}
	}
	else if ( reason == MeasuringTypeChange_SamePosition )
	{
		if ( flag == YES )
		{
			[log appendString:@"同一判定解除により標準測位に変更"];
		}
		else
		{
			[log appendString:@"同一判定により基地局測位に変更"];
		}
	}
	[log appendString:@"\n"];
    
	
	return log;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
   
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    /* ZDCジオフェンスライブラリに関する設定 */
    NSNumber *saveInterval = GFaGeoFenceManagerSettingDefault_SaveInterval;
	_geoFenceManager = [GeoFenceManager defaultManager];
	GeoFenceManagerSetParamResult result = [_geoFenceManager setParams:[self geoFenceInfo] saveInterval:saveInterval.integerValue operationMode:kGFlGeoFenceManagerOperationMode_ServerAccess];
    
	if (result != kGFlGeoFenceManagerSetParamSuccess) {
        return;
    }
    
    [_geoFenceManager updateAreaInformation];
 
    
    /* LocationManagerのデリゲート設定 */
    [LocationManager defaultLocationManager].delegate = self;
    
    _settings = [[NSMutableDictionary alloc] init];
    [self updateSettings];
    [self measuringStart];

    [self initIdfa];
    _idfa = [self advertisingIdentifier];
    
    _mapView.delegate = self;
    [_mapView setShowsBuildings:YES];
    [_mapView setShowsPointsOfInterest:YES];
    [_mapView setShowsUserLocation:YES];
    
    // view に追加
    [self.view addSubview:self.mapView];
}


- (void)viewDidAppear:(BOOL)animated {
    
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.location.coordinate, (FENCE_1 * 3.0), (FENCE_1 * 3.0));
        [_mapView setRegion:region animated:YES];
    
        //[self setGeofenceAt:_mapView.region.center];
        [self setGeofenceAt];
        _isMonitoring = YES;
    }
    
    [_mapView setCenterCoordinate:_centerLocation animated:NO];
    
    // 地図上の中点と縮尺を設定
    {
        MKCoordinateRegion region = _mapView.region;
        region.center = _centerLocation;
        region.span.latitudeDelta = 0.02;
        region.span.longitudeDelta = 0.02;
        [_mapView setRegion:region animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[LocationManager defaultLocationManager] measuringStop];
}

- (void)viewDidUnload {
    [[LocationManager defaultLocationManager] measuringStop];
    [super viewDidUnload];
}


- (void)updateSettings
{
    [(NSMutableDictionary *)_settings setValue:@"http://pacific-eyrie-5378.herokuapp.com/api/v1/gps" forKey:MeasuringSettingURLKey];
    [(NSMutableDictionary *)_settings setValue:@"JSZ5d27ae0bff62|1ALt9" forKey:MeasuringSettingSchemaKey];
    //[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)[_accuracyTextField.text integerValue]] forKey:MeasuringSettingAccuracyKey];
    //[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)[_distanceTextField.text integerValue]] forKey:MeasuringSettingDistanceKey];
    [(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)5.0] forKey:MeasuringSettingIntervalKey];
    [(NSMutableDictionary *)_settings setValue:[NSNumber numberWithBool:YES] forKey:MeasuringSettingPermissionKey];
    //[(NSMutableDictionary *)_settings setValue:_uidTextField.text forKey:MeasuringSettingUIDKey];
    //[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)[_samePosiDistanceTextField.text integerValue]] forKey:MeasuringSettingSamePositionDistanceKey];
    //[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithInt:[_samePosiCountTextField.text integerValue]] forKey:MeasuringSettingSamePositionCountKey];
    //[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)[_batteryLevelTextField.text integerValue]] forKey:MeasuringSettingBatteryLevIntervalKey];
	//[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithFloat:(float)[_significantTextField.text integerValue]] forKey:MeasuringSettingSignificantChangeAccuracyKey];
	//[(NSMutableDictionary *)_settings setValue:[NSNumber numberWithInt:[_logUploadCountTextField.text integerValue]] forKey:MeasuringSettingLogUploadCountKey];
    //[(NSMutableDictionary *)_settings setValue:_secretTextField.text forKey:MeasuringSettingSecretKey];
    //[(NSMutableDictionary *)_settings setValue:_paramTextField.text forKey:MeasuringSettingLogAppParamKey];
}


- (void)measuringStart {

    @synchronized (self) {
        NSMutableString *log = [NSMutableString stringWithString:@"測位開始："];
        
        /* 測位開始 */
        _times = 0;
        
        if ([[LocationManager defaultLocationManager] measuringStart:_settings] == YES) {
            [log appendString:@"成功"];
        } else {
            [log appendString:@"失敗"];
            
            // debug library only
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocationManagerTestNotification" object:nil];
        }
        [log appendFormat:@"\n設定 = \n%@\n\n", [_settings description]];
        [self showDialog:log];
    }
}

#pragma mark LocationManagerDelegate

/* 測位情報を通知するコールバック関数 */
- (void)measuringResult:(LocationInfo *)locationInfo status:(LocationManagerStatus)status error:(NSError *)error
{
    if (status == LocationManagerStatusError) {
        [self showDialog:@"測位に失敗しました。\n"];
    } else if (status == LocationManagerStatusPending) {
        [self showDialog:@"測位中です。\n"];
    } else {
        /* 出力ログの形成 */
        NSMutableString *log = [NSMutableString string];
        
        [log appendFormat:@"現在: %@\n", [NSDate date]];
        [log appendFormat:@"日付: %@          ", locationInfo.date];
        [log appendFormat:@"時間: %@\n", locationInfo.time];
        [log appendFormat:@"緯度: %+f       ", locationInfo.latitude];
        [log appendFormat:@"経度: %+f       ", locationInfo.longitude];
        [log appendFormat:@"誤差: %ld\n", (long)locationInfo.horizontalAccuracy];
        [log appendFormat:@"標高: %+f\n\n", locationInfo.altitude];
        
        //[self showDialog:log];
        
		NSString *logData = [self createLogData:locationInfo];
		if (logData != nil) {
			[self saveLogFile:logData];
		}
        
        _times++;
        //[_timesLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)_times]];
        //[_timesLabel setNeedsDisplay];
        
        // 緯度・軽度を設定
        _centerLocation.latitude = locationInfo.latitude;
        _centerLocation.longitude = locationInfo.longitude;
        
        // 内外判定
        [self checkLocation];
        
        [_mapView setCenterCoordinate:_centerLocation animated:NO];
    }
}


- (void)checkLocation {
    NSDate *nowDate = [NSDate date];
    NSLog(@"_centerLocation(%+f, %+f)", _centerLocation.latitude, _centerLocation.longitude);
    
    //_centerLocation.latitude = 35.3929;
    //_centerLocation.longitude = 139.4155;
    
    NSArray *checkResult = [_geoFenceManager checkLocation:nowDate latitude:_centerLocation.latitude longitude:_centerLocation.longitude horizontalAccuracy:300];
    for (NSDictionary *info in checkResult)
    {
        NSDictionary *notificationConditionInfo = [info objectForKey:GFlResponseTagKeyCondition];
        NSNumber *notificationID = [notificationConditionInfo objectForKey:GFlResponseKeyNid];
        
        NSDictionary *areaInfo = [info objectForKey:GFlResponseTagKeyArea];
        NSString *areaID = [areaInfo objectForKey:GFlResponseKeyAid];
        
        NSString *infoString = [NSString stringWithFormat:@"HIT!!  通知条件ID:[%@] エリアID:[%@]\n",
                                notificationID, areaID];
        NSLog(@"%@", infoString);
    }
}

/* 測位方法変更を通知するコールバック関数 */
- (void)changeMeasureStatus:(MeasuringType)measureStatus reason:(MeasuringTypeChangeReason)reason
{
	NSString *log = [self createStatusLogData:measureStatus reason:reason];
	
	if ([log length] > 0) {
		[self showDialog:log];
		[self saveLogFile:log];
	}
}


/* 位置測位ライブラリのエラーを通知するコールバック引数 */
- (void)errorStatus:(LocationManagerErrorStatus)errorStatus detailInfo:(NSDictionary *)willBeNil
{
    switch (errorStatus) {
        case LocationManagerErrorStatus_ServerAuthenticationFailure:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"認証エラー"
                                                                 message:@"サーバー認証に失敗しました.\n測位を停止します."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [alertView show];
        }
            break;
    }
}

- (void)initIdfa
{
    if (![self isAdvertisingTrackingEnabled])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limit Ad Tracking"
                                                        message:@"Your AdvertisingTracking setting is Limit Ad Tracking."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (NSString *) advertisingIdentifier
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString *) identifierForVendor
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return @"";
}

- (BOOL)isAdvertisingTrackingEnabled
{
    if (NSClassFromString(@"ASIdentifierManager") &&
        (![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]))
    {
        return NO;
    }
    return YES;
}


- (NSDictionary *)geoFenceInfo
{
	NSDictionary *info = @{
                           GFlRequestParamKeyClientid : GFaGeoFenceManagerSettingDefault_Clientid,
                           GFlRequestParamKeySecret : GFaGeoFenceManagerSettingDefault_Secret,
                           GFlRequestParamKeyTntp : GFaGeoFenceManagerSettingDefault_Tntp,
                           GFlRequestParamKeyTatp : GFaGeoFenceManagerSettingDefault_Tatp,
                           GFlRequestParamKeyTmid : GFaGeoFenceManagerSettingDefault_Tmid,
                           GFlNotificationConditionServerURLKey : GFaGeoFenceManagerSettingDefault_NotificationConditionServerURL,
                           GFlAreaInformationServerURLKey : GFaGeoFenceManagerSettingDefault_AreaInformatioinServerURL,
                           
                           };
	
	return info;
}

#pragma mark - GeoFence job
- (void)setGeofenceAt
{
    NSArray *info = [_geoFenceManager areaInformationList:nil];;
    if(info.count < 1) {
        /* 該当なし */
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"該当するエリア情報はありません"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    

    // 例えば先頭のエリアだけ描画してみる
    NSDictionary *dic = info[0];
    NSString *lati = [dic objectForKey:@"lat"];
    NSString *loni = [dic objectForKey:@"lon"];
    NSLog(@"lat = %@", lati);
    NSLog(@"lon = %@", loni);

    CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake([lati doubleValue], [loni doubleValue]);
    
    [_mapView removeOverlays:_mapView.overlays];
	MKCircle *_fenceRange1 = [MKCircle circleWithCenterCoordinate:centerLocation radius:FENCE_1];
    
	[_mapView addOverlay:_fenceRange1 level:MKOverlayLevelAboveRoads];
    
	_regionNearby = [[CLCircularRegion alloc] initWithCenter:_fenceRange1.coordinate radius:_fenceRange1.radius identifier:@"nearby"];
	_regionNearby.notifyOnEntry = YES;
	_regionNearby.notifyOnExit  = YES;
   
}

// オーバーレイ描画イベント
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if(_isMonitoring) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle*)overlay];
        renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        renderer.lineWidth = 1.0;
        renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        return (MKOverlayRenderer*)renderer;
    }
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
