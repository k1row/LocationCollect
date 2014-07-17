package com.example.s_geomapsample.sample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import jp.co.zdc.geofencelib.GeoFenceManager;

/**
 * ジオフェンスに設定する情報を管理するクラス
 * @author kazuya
 *
 */
public class GeoFenceSettingDataModel extends InfoDataModel {

	private static GeoFenceSettingDataModel myModel = new GeoFenceSettingDataModel();
	public static final String SAVE_INTERVAL = "SAVE_INTERVAL";
	private static final String SAVE_FILE_NAME	= "GeofenceSettingDataModel.dat";
	private static Boolean didLoaded = false;

	private GeoFenceSettingDataModel() {
		backToDefault();
	}

	public static GeoFenceSettingDataModel getInstance() {

		/* 初めてインスタンスを作成した際にファイルから情報を読み込む  */
		if ( didLoaded == false ) {
			didLoaded = true;
			myModel.loadFromFile(SAVE_FILE_NAME);
		}

		return myModel;
	}

	public void saveInformation() {
		saveToFile(SAVE_FILE_NAME);
	}

	@Override
	HashMap<String, String> getDefault() {
		HashMap<String, String> defaultMap = new HashMap<String, String>();

		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_CLIENTID, "JSZ3a03eb052f46|E7Tg6");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TMID, "t1000_1");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_SECRET, "eNphiW-zYeDhnj37IL86bJeijmA");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TNTP, "2");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TATP, "2");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_NCURL, "https://test-mlp.its-mo.com/mlp/v1_0/request/SearchNotifyConditionList.php");
		defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_AIURL, "https://test-mlp.its-mo.com/mlp/v1_0/request/SearchAreaInfoList.php");
		defaultMap.put(SAVE_INTERVAL, "2");
		
		return defaultMap;
	}
	
	
	/** 設定値のデフォルトを定義  */
	/*@{*/
//	#define GFaLocationManagerSettingDefault_URL                @"http://test.fw.its-mo.com/position_log/data.php"
//	#define GFaLocationManagerSettingDefault_LogAppParam        @""
//	#define GFaLocationManagerSettingDefault_Scheme             @"REGISTER_POINT_TEST"
//	#define GFaLocationManagerSettingDefault_Accuracy           0
//	#define GFaLocationManagerSettingDefault_Distance           0
//	#define GFaLocationManagerSettingDefault_Interval           5
//	#define GFaLocationManagerSettingDefault_Permission         (NO)
//	#define GFaLocationManagerSettingDefault_PushMessageDate    @""
//	#define GFaLocationManagerSettingDefault_PushMessage        @""
//	#define GFaLocationManagerSettingDefault_SettingServerURL   @"http://test.fw.its-mo.com/density"
//	#define GFaLocationManagerSettingDefault_AppID              @"APPID_SAMPLE_APP"
//	#define GFaLocationManagerSettingDefault_UID                @"UID_SAMPLE_APP"
//
//	#define GFaGeoFenceManagerSettingDefault_Clientid			@"JSZ3a03eb052f46|E7Tg6"
//	#define GFaGeoFenceManagerSettingDefault_Tntp				@(2)
//	#define GFaGeoFenceManagerSettingDefault_Secret             @"eNphiW-zYeDhnj37IL86bJeijmA"
//	#define GFaGeoFenceManagerSettingDefault_Tatp               @(1)
//	#define GFaGeoFenceManagerSettingDefault_Tmid				@"t1000_1"
//	#define GFaGeoFenceManagerSettingDefault_NotificationConditionServerURL    @"https://test-mlp.its-mo.com/mlp/v1_0/request/SearchNotifyConditionList.php"
//	#define GFaGeoFenceManagerSettingDefault_AreaInformatioinServerURL         @"https://test-mlp.its-mo.com/mlp/v1_0/request/SearchAreaInfoList.php"

	
	
	

	/**
	 *	GeoFenceManagerにセットする時にIntegerにする物のリスト
	 * */
	private ArrayList<String> getConvertIntegerArrayList() {
		ArrayList<String> list = new ArrayList<String>();

		list.add(GeoFenceManager.REQUEST_PARAM_KEY_TNTP);
		list.add(GeoFenceManager.REQUEST_PARAM_KEY_TATP);
		list.add(SAVE_INTERVAL);

		return list;
	}

	/**
	 * ジオフェンスマネージャーにセットする辞書を作成して返す
	 * @return HashMap
	 */
	@SuppressWarnings("rawtypes")
	public HashMap<String, Object> getGeoFenceManagerSetParam() {
		HashMap<String, Object> map = new HashMap<String, Object>();
		ArrayList<String> intConvertList = getConvertIntegerArrayList();

		for ( Iterator<Entry<String, String>> it = myHash.entrySet().iterator(); it.hasNext(); ) {
			Map.Entry entry = (Map.Entry)it.next();
			String key = (String)entry.getKey();
			Object value = entry.getValue();

			if ( intConvertList.contains(key) == true && ((String)value).length() > 0 ) {
				value = (Integer)Integer.valueOf((String)value);
			}

			map.put(key, value);
		}

		return map;
	}
}
