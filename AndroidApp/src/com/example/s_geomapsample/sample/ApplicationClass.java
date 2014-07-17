package com.example.s_geomapsample.sample;

import jp.co.zdc.geofencelib.GeoFenceManager;
import android.app.Application;
import android.content.Context;
import android.content.Intent;

import com.example.s_geomapsample.LocationServiceManager.OnNotifiedMessageListener;

public class ApplicationClass extends Application
{
	private OnNotifiedMessageListener mNotifiedMessageListener;
	private LocationSettings mLocationSettings;
	private GeoFenceManager mGeoFenceManager;
	private static Context context;

	
	
	@Override
	public void onCreate()
	{
		super.onCreate();
		ApplicationClass.context = getApplicationContext();
	}
	
	public static Context getAppContext()
	{
		return ApplicationClass.context;
	}

	/**
	 * 位置測位ライブラリリスナー設定
	 * @param listener
	 */
	public void setOnNotifiedMessageListener(OnNotifiedMessageListener listener)
	{
		mNotifiedMessageListener = listener;
	}

	/**
	 * 位置測位結果
	 * @param intent
	 */
	public void notifyLocation(Intent intent)
	{
		if(mNotifiedMessageListener != null)
		{
			mNotifiedMessageListener.onNotifiedLocation(intent);
		}
	}

	/**
	 * 位置測位ライブラリパラメータ取得
	 * @return 測位開始パラメータ
	 */
	public LocationSettings getLocationSettings()
	{
		if(mLocationSettings == null)
		{
			mLocationSettings = LocationSettings.loadFromSavedFile(ApplicationClass.getAppContext());
			if ( mLocationSettings == null )
			{
				mLocationSettings = new LocationSettings();
			}
		}

		return mLocationSettings;
	}

	/**
	 * ジオフェンスライブラリのインスタンス取得
	 * @return ジオフェンスライブラリのインスタンス
	 */
	public GeoFenceManager getGeoFenceManager()
	{
//		mGeoFenceManager.setParams(param, saveInterval)
//		mGeoFenceManager.updateAreaInfomation()
//		mGeoFenceManager.checkLocation(latidude, longidude, accuracy, date)
		
		
		if(mGeoFenceManager == null)
		{
			mGeoFenceManager = new GeoFenceManager(getApplicationContext());
		}
		return mGeoFenceManager;
	}
}
