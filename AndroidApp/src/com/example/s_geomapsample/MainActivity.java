package com.example.s_geomapsample;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import jp.co.zdc.geofencelib.GeoFenceManager;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.example.s_geomapsample.LocationServiceManager.OnNotifiedMessageListener;
import com.example.s_geomapsample.sample.ApplicationDefine;
import com.example.s_geomapsample.sample.callback.UpdateReceiver;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;

public class MainActivity extends FragmentActivity implements LocationListener {

	private GeoFenceManager mGeoFenceManager;

	private int mValueMaxCount = 20;

	private TextView mLatitude;
	private TextView mAccuracy;
	private TextView mLongitude;
	private TextView mProvider;

	private GoogleMap gMap;
	public double latitude = 0;
	public double longitude = 0;

	private static Handler mHandler;

	private static final int MENU_A = 0;
	private static final int MENU_B = 1;

	private List<String> mCurrentValueList = new ArrayList<String>();

	private UpdateReceiver upReceiver;
	private IntentFilter intentFilter;

	@SuppressLint("SimpleDateFormat")
	@SuppressWarnings("unchecked")
	private void checkArea(double latitude, double longitude, float accuracy, Date date) {
		List<String> valueList = new ArrayList<String>();
		String newString = "";

		String paramString = null;
		String resultString = "";

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		String dateString = sdf.format(date);
		paramString = String.format("日時:[%s]\n経度:[%s]\n緯度:[%s]\n誤差:[%s]\n", dateString, String.valueOf(latitude),
				String.valueOf(longitude), String.valueOf(accuracy));

		// TODO ジオフェンス地点が返却される？　入ってこない
		List<?> retList = mGeoFenceManager.checkLocation(latitude, longitude, accuracy, date);

		if (retList != null) {
			for (Object obj : retList) {
				HashMap<String, Object> item = null;
				if (obj instanceof HashMap<?, ?>) {
					item = (HashMap<String, Object>) obj;
					HashMap<String, Object> areaInfo = (HashMap<String, Object>) item
							.get(GeoFenceManager.RESPONSE_TAG_KEY_AREA);
					String areaID = (String) areaInfo.get(GeoFenceManager.RESPONSE_KEY_AID);
					HashMap<String, Object> conditionInfo = (HashMap<String, Object>) item
							.get(GeoFenceManager.RESPONSE_TAG_KEY_CONDITION);
					String notificationID = String.valueOf((Integer) conditionInfo
							.get(GeoFenceManager.RESPONSE_KEY_NID));

					resultString = resultString
							+ String.format("*** 通知条件ID:[%s] エリアID:[%s] ***\n", notificationID, areaID);
				}
			}
		} else {
			Toast.makeText(this, "geoFenceManager.checkLocation  が取得できなかった", Toast.LENGTH_LONG).show();
		}

		newString = resultString + paramString + "\n";
		valueList.add(newString);
		for (int i = 0; i < mCurrentValueList.size(); i++) {
			newString += mCurrentValueList.get(i);
			valueList.add(mCurrentValueList.get(i));
			if (valueList.size() == mValueMaxCount)
				break;
		}

		mCurrentValueList = null;
		mCurrentValueList = new ArrayList<String>(valueList);
		valueList = null;

		System.out.println("☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆エリア判定 = " + newString);

	}

	private OnNotifiedMessageListener mNotifiedMessageListener = new OnNotifiedMessageListener() {
		// 測位結果
		@Override
		public void onNotifiedLocation(Intent intent) {
			final String result = intent.getStringExtra("Result");
			if (result == null) {
				return;
			}

			final Intent handleIntent = intent;
			mHandler.post(new Runnable() {
				@SuppressLint("SimpleDateFormat")
				@Override
				public void run() {
					if (result.equals("OK")) {
						StringBuilder messageString = new StringBuilder();
						// プロバイダー
						String provider = handleIntent.getStringExtra(ApplicationDefine.PROVIDER);
						setIntentString(provider, "Provider", messageString);
						// 緯度
						Double latitude = handleIntent.getDoubleExtra(ApplicationDefine.LATITUDE, Double.MIN_VALUE);
						setIntentDouble(latitude, "Latitude", messageString);
						// 経度
						Double longitude = handleIntent.getDoubleExtra(ApplicationDefine.LONGITUDE, Double.MIN_VALUE);
						setIntentDouble(longitude, "Longitude", messageString);
						// 精度
						Float accuracy = handleIntent.getFloatExtra(ApplicationDefine.ACCURACY, Float.MIN_VALUE);
						setIntentFloat(accuracy, "Accuracy", messageString);
						// 標高
						Double altitude = handleIntent.getDoubleExtra(ApplicationDefine.ALTITUDE, Double.MIN_VALUE);
						setIntentDouble(altitude, "Altitude", messageString);
						// 日付
						Date date = (Date) handleIntent.getSerializableExtra(ApplicationDefine.DATE);
						if (date != null) {
							String dateString = new SimpleDateFormat("yyyyMMdd").format(date);
							setIntentString(dateString, "Date", messageString);
							String timeString = new SimpleDateFormat("HHmmss").format(date);
							setIntentString(timeString, "Time", messageString);
						}

						// 画面に受信結果を表示
						// mLocationResult.setText(messageString.toString());
						// TODO
						// GeoFenceライブラリでエリア判定
						checkArea(latitude.doubleValue(), longitude.doubleValue(), accuracy.floatValue(), date);
					}
				}
			});
		}
	};

	private void setIntentDouble(double value, String valueName, StringBuilder appendStr) {
		if ((value != -1) && (valueName != null)) {
			appendStr.append(valueName + " : " + value + "\r\n");
		}
	}

	private void setIntentString(String value, String valueName, StringBuilder appendStr) {
		if (value != null && valueName != null) {
			appendStr.append(valueName + " : " + value + "\r\n");
		}
	}

	private void setIntentFloat(float value, String valueName, StringBuilder appendStr) {
		if ((value != -1) && (valueName != null)) {
			appendStr.append(valueName + " : " + value + "\r\n");
		}
	}

	private LocationServiceManager mLocationManager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_sample_map);

		mLatitude = (TextView) findViewById(R.id.latitude);
		mAccuracy = (TextView) findViewById(R.id.accuracy);
		mLongitude = (TextView) findViewById(R.id.longitude);

		mProvider = (TextView) findViewById(R.id.t01);

		mHandler = new Handler();

		// mApp = (ApplicationClass) getApplication();
		// mApp.setOnNotifiedMessageListener(mNotifiedMessageListener);
		// mLocationManager = new LocationServiceManager(getApplication());

		upReceiver = new UpdateReceiver();
		intentFilter = new IntentFilter();
		intentFilter.addAction("UPDATE_ACTION");
		registerReceiver(upReceiver, intentFilter);

		upReceiver.registerHandler(updateHandler);

		// パラメータをセットする
		Button setParamButton = (Button) findViewById(R.id.param);
		setParamButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				mGeoFenceManager = new GeoFenceManager(MainActivity.this);
				HashMap<String, Object> defaultMap = new HashMap<String, Object>();
				{
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_CLIENTID, "JSZ3a03eb052f46|E7Tg6");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TMID, "t1000_1");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_SECRET, "eNphiW-zYeDhnj37IL86bJeijmA");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TNTP, "1");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_TATP, "1");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_NCURL,
							"https://test-mlp.its-mo.com/mlp/v1_0/request/SearchNotifyConditionList.php");
					defaultMap.put(GeoFenceManager.REQUEST_PARAM_KEY_AIURL,
							"https://test-mlp.its-mo.com/mlp/v1_0/request/SearchAreaInfoList.php");
					defaultMap.put("SAVE_INTERVAL", "2");
				}

				int result = mGeoFenceManager.setParams(defaultMap, 1);
				if (result == GeoFenceManager.SET_PARAMS_RESULT_CODE_SUCCESS) {
					Toast.makeText(MainActivity.this, "SET_PARAMS_RESULT_CODE_SUCCESS", Toast.LENGTH_LONG).show();
				} else if (result == GeoFenceManager.SET_PARAMS_RESULT_CODE_NO_REQUIRED) {
					Toast.makeText(MainActivity.this, "SET_PARAMS_RESULT_CODE_NO_REQUIRED", Toast.LENGTH_LONG).show();
				}
			}
		});

		// Area更新
		Button updateButton = (Button) findViewById(R.id.update);
		updateButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {

				int updateAreaInfomation = mGeoFenceManager.updateAreaInfomation();
				Toast.makeText(MainActivity.this, "updateAreaInfomation = " + updateAreaInfomation, Toast.LENGTH_LONG)
						.show();
				// UpdateAreaAsync areaAsync = new
				// UpdateAreaAsync(MainActivity.this, mGeoFenceManager);
				// areaAsync.execute();
			}
		});
		// GPSで何かするボタン
		Button gpsButton = (Button) findViewById(R.id.gps_button);
		gpsButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				LocationServiceManager locationServiceManager = new LocationServiceManager(MainActivity.this);
				locationServiceManager.startLocationService();
			}
		});

		// Google Play Servicesが使えるかどうかのステータス
		int status = GooglePlayServicesUtil.isGooglePlayServicesAvailable(getBaseContext());

		// Showing status
		if (status != ConnectionResult.SUCCESS) {
			// Google Play Services が使えない場合
			int requestCode = 10;
			Dialog dialog = GooglePlayServicesUtil.getErrorDialog(status, this, requestCode);
			dialog.show();

		} else {
			// Google Play Services が使える場合
			// activity_main.xmlのSupportMapFragmentへの参照を取得
			SupportMapFragment fm = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);

			// fragmentからGoogleMap objectを取得
			gMap = fm.getMap();

			// Google MapのMyLocationレイヤーを使用可能にする
			gMap.setMyLocationEnabled(true);
			gMap.setIndoorEnabled(true);
			gMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
			gMap.setTrafficEnabled(true);

			// システムサービスのLOCATION_SERVICEからLocationManager objectを取得
			LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);

			// retrieve providerへcriteria objectを生成
			Criteria criteria = new Criteria();

			// Best providerの名前を取得
			String provider = locationManager.getBestProvider(criteria, true);

			// 現在位置を取得
			Location location = locationManager.getLastKnownLocation(provider);

			if (location != null) {
				onLocationChanged(location);
			}
			locationManager.requestLocationUpdates(provider, 20000, 0, this);

		}

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		// getMenuInflater().inflate(R.menu.activity_main, menu);

		menu.add(0, MENU_A, 0, "Home");
		menu.add(0, MENU_B, 0, "Legal Notices");
		return true;
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case MENU_A:
			// 復帰
			LatLng HOME = new LatLng(35.02878398517723, 135.77929973602295);
			moveCamera2Target(true, HOME, 18.0f, 60.0f, 0.0f);
			return true;

		case MENU_B:
			// Legal Notices
			String LicenseInfo = GooglePlayServicesUtil.getOpenSourceSoftwareLicenseInfo(getApplicationContext());
			AlertDialog.Builder LicenseDialog = new AlertDialog.Builder(MainActivity.this);
			LicenseDialog.setTitle("Legal Notices");
			LicenseDialog.setMessage(LicenseInfo);
			LicenseDialog.show();

			return true;
		}
		return false;
	}

	@Override
	protected void onResume() {

		super.onResume();

	}

	private void moveCamera2Target(boolean animation_effect, LatLng target, float zoom, float tilt, float bearing) {
		CameraPosition pos = new CameraPosition(target, zoom, tilt, bearing);
		CameraUpdate camera = CameraUpdateFactory.newCameraPosition(pos);

		if (animation_effect == true) {
			//
			gMap.animateCamera(camera);
		} else {
			//
			gMap.moveCamera(camera);
		}
	}

	@Override
	public void onLocationChanged(Location location) {

		// // 現在位置の緯度を取得
		// latitude = location.getLatitude();
		//
		// // 現在位置の経度を取得
		// longitude = location.getLongitude();
		//
		// textview.setText(latitude + "," + longitude);
		// // reverse_geocode(latitude,longitude);
		//
		// // 現在位置からLatLng objectを生成
		// LatLng latLng = new LatLng(latitude, longitude);
		//
		// // Google Mapに現在地を表示
		// gMap.moveCamera(CameraUpdateFactory.newLatLng(latLng));
		//
		// // Google Mapの Zoom値を指定
		// gMap.animateCamera(CameraUpdateFactory.zoomTo(15));

	}

	@Override
	public void onProviderDisabled(String provider) {
		// TODO Auto-generated method stub
	}

	@Override
	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub
	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub
	}

	// サービスから値を受け取ったら動かしたい内容を書く
	private Handler updateHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			Bundle bundle = msg.getData();

			double latitude = bundle.getDouble("latitude");
			float accuracy = bundle.getFloat("accuracy");
			double longitude = bundle.getDouble("longitude");

			String provider = bundle.getString("Provider");

			Log.d("Activityの名前", "latitude " + latitude);
			Log.d("Activityの名前", "accuracy " + accuracy);
			Log.d("Activityの名前", "longitude " + longitude);
			Log.d("Activityの名前", "provider " + provider);

			mLatitude.setText("Latitude " + String.valueOf(latitude));
			mAccuracy.setText("Accuracy " + String.valueOf(accuracy));
			mLongitude.setText("Longitude " + String.valueOf(longitude));
			mProvider.setText("provider " + String.valueOf(provider));

			CameraUpdate cu = CameraUpdateFactory.newLatLngZoom(new LatLng(latitude, longitude), accuracy);
			gMap.moveCamera(cu);

			Date date = new Date();

			checkArea(latitude, longitude, accuracy, date);
		}
	};
}
