package com.example.s_geomapsample.sample;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.io.StreamCorruptedException;

import android.content.Context;

/**
 * 位置測位ライブラリ起動パラメータ設定
 */
public class LocationSettings implements Serializable
{

	private static final long serialVersionUID = 1L;
	/** 設定可能 */
	private String		mSID;	// SID
	private String		mUID;	// UID
	private String		mAPPID;	// APPID
	private Integer		mInterval;	// 測位間隔
	private String[]	mProvider;
	private String		mPermissionLocationHistory;	// 位置情報ログ送信許可
	private String[]	mLogServerURL;	// 位置情報サーバー
	private String		mSettingServerURL;	// 設定変更情報サーバー
	private Boolean		mDebugMode;	// デバッグモード

	/** 固定値 */
	private String		mOperation;	// 測位種類
	private String		mPermissionLocationRestart;	// 端末起動時の測位再開許可
	private String		mPermissionDefaultStandeing;	// 測位停止後の測位モード
	private String		mPermissionPushMessage;	// PUSH通位の通知許可

	public static final String SAVE_FILE_NAME = "LocationSettings.dat";

	public LocationSettings()
	{
		// 初期値
		mSID = "GEOFENCE_SAMPLE_SID";
		mUID = "GEOFENCE_SAMPLE_UID";
		mAPPID = "GEOFENCE_SAMPLE_APPID";
		mInterval = 10;
		mLogServerURL = new String[1];
		mLogServerURL[0] = "http://test.fw.its-mo.com/position_log/data.php";
		mSettingServerURL = "http://test.fw.its-mo.com/density/location_setting.cgi";
		String provider[] = {"GPS", "NETWORK", "DOCOMO"};
		mProvider = provider;

		mOperation = "START";
		mPermissionLocationHistory = "OFF";
		mPermissionPushMessage = "OFF";
		mPermissionLocationRestart = "OFF";
		mPermissionDefaultStandeing = "OFF";
		mDebugMode = false;
	}

	public static LocationSettings loadFromSavedFile(Context context) {
		LocationSettings loadedLocationSettings = null;

		try {
			FileInputStream fis = context.openFileInput(SAVE_FILE_NAME);
			ObjectInputStream ois = new ObjectInputStream(fis);
			loadedLocationSettings = (LocationSettings) ois.readObject();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		return loadedLocationSettings;
	}

	public void saveToFile(Context context) {
		try {
			FileOutputStream fos = context.openFileOutput(SAVE_FILE_NAME, Context.MODE_PRIVATE);
			ObjectOutputStream oos = new ObjectOutputStream(fos);
			oos.writeObject(this);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public String getSID()
	{
		return mSID;
	}
	public void setSID(String sid)
	{
		this.mSID = sid;
	}

	public String getUID()
	{
		return mUID;
	}
	public void setUID(String uid)
	{
		this.mUID = uid;
	}

	public String getAPPID()
	{
		return mAPPID;
	}
	public void setAPPID(String appid)
	{
		this.mAPPID = appid;
	}

	public Integer getInterval()
	{
		return mInterval;
	}
	public void setInterval(Integer interval)
	{
		this.mInterval = interval;
	}

	public String getOperation()
	{
		return mOperation;
	}

	public void setProvider(String[] provider)
	{
		this.mProvider = null;
		this.mProvider = provider;
	}

	public String[] getProvider()
	{
		return mProvider;
	}

	public void setPermissionLocationHistory(boolean locationHistoryMode)
	{
		if (locationHistoryMode == true)
		{
			this.mPermissionLocationHistory = "ON";
		}
		else
		{
			this.mPermissionLocationHistory = "OFF";
		}
	}

	public String getPermissionLocationHistory()
	{
		return mPermissionLocationHistory;
	}

	public void setLogServerURL(String logServerURL)
	{
		this.mLogServerURL[0] = logServerURL;
	}

	public String[] getLogServerURL()
	{
		return mLogServerURL;
	}

	public String getPermissionPushMessage()
	{
		return mPermissionPushMessage;
	}

	public void setSettingServerURL(String settingServerURL)
	{
		this.mSettingServerURL = settingServerURL;
	}

	public String getSettingServerURL()
	{
		return mSettingServerURL;
	}

	public String getPermissionLocationRestart()
	{
		return mPermissionLocationRestart;
	}

	public String getPermissionDefaultStandeing()
	{
		return mPermissionDefaultStandeing;
	}

	public void setDebugMode(boolean mode)
	{
		this.mDebugMode = mode;
	}

	public Boolean getDebugMode()
	{
		return mDebugMode;
	}
}
