package com.example.s_geomapsample;

import java.util.ArrayList;
import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import com.example.s_geomapsample.sample.ApplicationDefine;
import com.example.s_geomapsample.service.LocationReceiveService;

public class LocationServiceManager {

	private static final String BETTER_LOCATION_SERVICE = "jp.co.zdc.location.request.service.LocationRequestService";

	// private LocationSettings mSettings;
	private Context mContext;
	private String mLibPackage;

	// BetterLocationRequestServiceのリスナー
	public interface OnNotifiedMessageListener { // 測位結果リスナー
		public void onNotifiedLocation(Intent intent);
	}

	/**
	 * コンストラクタ
	 * 
	 * @param context
	 * @param application
	 *            ApplicationClass
	 */
	public LocationServiceManager(Context context) {
		// mSettings = application.getLocationSettings();
		mContext = context;
	}

	/**
	 * 位置測位ライブラリ開始
	 */
	public void startLocationService() {
		Intent intent = new Intent();
		if (chkService() == true) {
			// 稼働中のライブラリを使用
			intent.setComponent(new ComponentName(mLibPackage, BETTER_LOCATION_SERVICE));
		} else {
			// 自身のライブライを使用
			intent.setComponent(new ComponentName(mContext.getPackageName(), BETTER_LOCATION_SERVICE));
		}

		// 開始パラメータ設定
		intent.putExtra(ApplicationDefine.SID_KEY, "JSZ3a03eb052f46|E7Tg6");
		intent.putExtra(ApplicationDefine.UID_KEY, "GEOFENCE_SAMPLE_UID");
		intent.putExtra(ApplicationDefine.APPID_KEY, "eNphiW-zYeDhnj37IL86bJeijmA");
		intent.putExtra(ApplicationDefine.INTERVAL_KEY, 10000);
		intent.putExtra(ApplicationDefine.OPERATION_KEY, "START");

		String[] provider = new String[3];
		provider[0] = "GPS";
		provider[1] = "NETWORK";
		provider[2] = "DOCOMO";
		intent.putExtra(ApplicationDefine.PROVIDER_KEY, provider);
		intent.putExtra(ApplicationDefine.LOCATION_HISTORY_KEY, "OFF");
		String[] serverUrl = { "http://test.fw.its-mo.com/position_log/data.php" };
		intent.putExtra(ApplicationDefine.LOG_SERVER_URL_KEY, serverUrl);
		intent.putExtra(ApplicationDefine.PACKAGE_NAME_KEY, MainActivity.class.getPackage().getName());
		intent.putExtra(ApplicationDefine.CLASS_NAME_KEY, LocationReceiveService.class.getName());
		intent.putExtra(ApplicationDefine.PERMISSION_LOCATION_RESTART_KEY, "OFF");
		intent.putExtra(ApplicationDefine.PERMISSION_PUSH_MESSAGE_KEY, "OFF");
		intent.putExtra(ApplicationDefine.SETTING_SERVER_URL_KEY,
				"http://test.fw.its-mo.com/density/location_setting.cgi");
		intent.putExtra(ApplicationDefine.CLASS_NAME_TO_SETTING_KEY, LocationReceiveService.class.getName());
		intent.putExtra(ApplicationDefine.PERMISSION_DEFAULT_LOCATION_KEY, "OFF");
		intent.putExtra(ApplicationDefine.DEBUG_KEY, false);

		mContext.startService(intent);
	}

	/**
	 * 位置測位ライブラリ停止
	 */
	public void stopLocationService() {
		Intent intent = new Intent();
		if (chkService() == true) {
			// 稼働中のライブラリを使用
			intent.setComponent(new ComponentName(mLibPackage, BETTER_LOCATION_SERVICE));
		} else {
			// 自身のライブラリを使用
			intent.setComponent(new ComponentName(mContext.getPackageName(), BETTER_LOCATION_SERVICE));
		}

		intent.putExtra(ApplicationDefine.OPERATION_KEY, "STOP");
		// intent.putExtra(ApplicationDefine.SID_KEY, mSettings.getSID());

		mContext.startService(intent);
	}

	/**
	 * 位置測位ライブラリ稼働状況の判定
	 * 
	 * @param context
	 * @return ライブラリサービス稼働状況 true:稼働中 false:未稼働
	 */
	private boolean chkService() {
		boolean ret = false;
		ArrayList<String> serviceList = new ArrayList<String>();
		ActivityManager activityManager = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
		// 起動中のサービス情報を取得
		List<RunningServiceInfo> runningService = activityManager.getRunningServices(100);
		if (runningService != null) {
			for (RunningServiceInfo srvInfo : runningService) {
				serviceList.add(srvInfo.service.getShortClassName());
			}
		}

		String className;
		for (int i = 0; i < serviceList.size(); i++) {
			className = serviceList.get(i);
			if (className.compareTo(".request.service.BetterLocationRequestService") == 0) {
				ret = true;
				mLibPackage = runningService.get(i).process.toString();
			}
			if (className.compareTo(BETTER_LOCATION_SERVICE) == 0) {
				ret = true;
				mLibPackage = runningService.get(i).process.toString();
			}
		}

		return ret;
	}
}
