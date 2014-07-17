//
//  PoicaViewController.m
//  AirTrack
//
//  Created by Keiichiro Nagashima on 2014/06/16.
//  Copyright (c) 2014年 Keiichiro Nagashima. All rights reserved.
//

#import "PoicaViewController.h"
#import "PSPoiCaSensorDelegate.h"
#import "PSPoiCaSensor.h"

static NSString *const IPPoiCaSensorAccessKey = @"8ad072a2-7e77-4c73-bdfd-118db4e00866";


@interface PoicaViewController ()<PSPoiCaSensorDelegate>

@end

@implementation PoicaViewController {
    NSString *_token;
    NSString *_uid;
    BOOL _needRetry;
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
 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [self initPoica:launchOptions];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma Poica Methods
- (void)displayMessage:(NSString *)message
{
    NSLog(@"%@", message);
}

- (void)registerDeviceWithToken:(NSString *)token andUID:(NSString *)uid
{
    // Appleのプッシュ通知トークンとPoiCa SensorのuidをPoiCa Noticeにペアで登録します。
    // デバイスが検知された場合、PoiCa Sensor検出サーバからPoiCa Notice通知サーバの配信トリガーが呼び出されます。
    // PoiCa Notice通知サーバは、uidとペアで登録されたプッシュ通知トークンに対してメッセージを配信します。
    NSURL *url = [NSURL URLWithString:@"https://notice.poica.net/api/v1/register_destination"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSDictionary *body = @{@"accessKey": IPPoiCaSensorAccessKey, @"platform": @"ios", @"token": token, @"locale": [[NSLocale currentLocale] localeIdentifier], @"uid": uid};
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:body options:0 error:NULL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            if (statusCode == 200) {
                [self displayMessage:@"PoiCa Noticeサービスにデバイスを登録しました。"];
            }
            else {
                [self displayMessage:[NSString stringWithFormat:@"PoiCa Noticeサービスにデバイスを登録できませんでした。 : %@", [NSHTTPURLResponse localizedStringForStatusCode:statusCode]]];
            }
        }
        else {
            [self displayMessage:[NSString stringWithFormat:@"PoiCa Noticeサービスにデバイスを登録できませんでした。 : %@", [error description]]];
        }
    }];
}

- (void)initPoica:(NSDictionary *)launchOptions
{
    // センサーのインスタンスはシングルトンです。
    // アクセスキーを設定しないと失敗するメソッドがあるので最初に設定します。
    // デリーゲートは処理結果を受け取るために必要です。
    PSPoiCaSensor *poiCaSensor = [PSPoiCaSensor sharedInstance];
    [poiCaSensor setAccessKey:IPPoiCaSensorAccessKey];
    [poiCaSensor setDelegate:self];
    
    // BLEを用いる場合はPoiCa Sensor検知装置のモニタリングを開始します。
    // WiFiは用いる場合はPoiCa Sensor検知装置側がデバイスのモニタリングを行うため、この処理は不要です。
    // アプリケーションはバックグラウンドで起動される場合があり、applicationDidBecomeActive:はモニタリングの開始には適しません。
    if ([poiCaSensor isDetectingAvailableForBLE]) {
        [poiCaSensor startMonitoringForBLE];
    }
    
    // 対応している検知方式に合わせてデバイスを登録します。
    // uidは定期的に変更される可能性があるため、アプリケーションの起動毎に呼び出してください。
    // 失敗した場合は、ネットワーク接続の回復あるいはアプリケーションがアクティブになったタイミングでリトライしてください。
    // iOS 7でBLE搭載デバイスの場合はBLE検知用に登録します。
    if ([poiCaSensor isDetectingAvailableForBLE]) {
        [poiCaSensor registerDeviceForBLE];
    }
    // iOS 6の場合はWiFi検知用に登録します。
    else if ([poiCaSensor isDetectingAvailableForWiFi]) {
        [poiCaSensor registerDeviceForWiFi];
    }
    // iOS 7でBLE非搭載デバイス(iPhone 4とiPad 2)の場合は、無線LANアクセスポイントを使ってWiFi検知用に登録します。
    // この登録方法はユーザオペレーションやインフラが煩雑になるため、サポートしないという判断もあり得ます。
    else {
        [poiCaSensor registerDeviceForWiFiWithSensor];
    }
    
    // Appleのプッシュ通知は、アプリが実行中に受信した場合と実行していない状態で受信した場合で受け取り方が異なります。
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayMessage:[NSString stringWithFormat:@"アプリが実行していない間にAppleのプッシュ通知を受信しました。 : %@", userInfo[@"aps"][@"alert"]]];
        });
    }
}

- (void)didBecomeActiveforPoica
{
    // デバイスの登録に失敗している場合はリトライします。
    // デモアプリケーションでは、アクティブになったタイミングでリトライを行っています。
    // 登録の成功済みか否かだけではなく、リクエスト中の再登録を避けられるようにフラグを使っています。
    if (_needRetry) {
        _needRetry = NO;
        
        PSPoiCaSensor *poiCaSensor = [PSPoiCaSensor sharedInstance];
        // iOS 7でBLE搭載デバイスの場合はBLE検知用に登録します。
        if ([poiCaSensor isDetectingAvailableForBLE]) {
            [poiCaSensor registerDeviceForBLE];
        }
        // iOS 6の場合はWiFi検知用に登録します。
        else if ([poiCaSensor isDetectingAvailableForWiFi]) {
            [poiCaSensor registerDeviceForWiFi];
        }
        // iOS 7でBLE非搭載デバイス(iPhone 4とiPad 2)の場合は、無線LANアクセスポイントを使ってWiFi検知用に登録します。
        // この登録方法はユーザオペレーションやインフラが煩雑になるため、サポートしないという判断もあり得ます。
        else {
            [poiCaSensor registerDeviceForWiFiWithSensor];
        }
    }
    
}

- (void)poiCaSensor:(PSPoiCaSensor *)poiCaSensor didFailMonitoringWithError:(NSError *)error
{
    // モニタリングのエラーは一度発生した事で後続の処理が止まるという事は無く、エラー発生時に随時起こります。
    // 多くの場合はネットワークの問題とユーザが位置情報サービスに許可を与えていない場合に発生します。
    // 位置情報サービスの不許可に対してユーザに何かメッセージを提示する場合は、エラーを受け取った場合にエラーの種類を解析してメッセージの表示を行うのではなく、アプリケーションがアクティブになったタイミングなどでCore Locationを使って、独自に許可状態を確認してメッセージを提示してください。
    // エラーによっては原因になったNSErrorをuserInfoに含んでいる場合があります。
    // 原因になったNSErrorは将来のライブラリで変化する可能性があるため、解析して処理を振り分ける事を避けてください。
    // 判断に利用できるのは、codeまでとなります。
    [self displayMessage:[NSString stringWithFormat:@"PoiCa Sensor検知装置のモニタリングでエラーが発生しました。 : %@", [error description]]];
}

- (void)poiCaSensor:(PSPoiCaSensor *)poiCaSensor didRegisterDeviceWithUID:(NSString *)uid
{
    _uid = uid;
    
    [self displayMessage:[NSString stringWithFormat:@"PoiCa Sensorサービスにデバイスを登録しました。 : %@", _uid]];
    
    // Appleのプッシュ通知トークンとPoiCa Sensorのuidが揃った場合はPoiCa Notice通知サーバにペアで登録します。
    if (_token && _uid) {
        [self registerDeviceWithToken:_token andUID:_uid];
    }
}

- (void)poiCaSensor:(PSPoiCaSensor *)poiCaSensor didFailToRegisterDeviceWithError:(NSError *)error
{
    [self displayMessage:[NSString stringWithFormat:@"PoiCa Sensorサービスにデバイスを登録できませんでした。 : %@", [error description]]];
    
    // ネットワーク接続の回復を監視する、あるいはアプリケーションがアクティブにされるなどのタイミングでリトライする必要があります。
    // デモアプリケーションでは、アクティブになったタイミングでリトライを行っています。
    // 登録の成功済みか否かだけではなく、リクエスト中の再登録を避けられるようにフラグを使っています。
    // エラーによっては原因になったNSErrorをuserInfoに含んでいる場合があります。
    // 原因になったNSErrorは将来のライブラリで変化する可能性があるため、解析して処理を振り分ける事を避けてください。
    // 判断に利用できるのは、codeまでとなります。
    _needRetry = YES;
}

@end
