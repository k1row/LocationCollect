package com.example.s_geomapsample.sample;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;

import com.example.s_geomapsample.R;

public class LocationSettingActivity extends Activity implements OnClickListener
{
	private ApplicationClass mApp;
	private LocationSettings mSettings;
	private Button mOK;
	private EditText mSID;
	private EditText mUID;
	private EditText mAPPID;
	private EditText mInterval;
	private CheckBox mGPSCheckBox;
	private CheckBox mNetworkCheckBox;
	private CheckBox mDocomoCheckBox;
	private CheckBox mSendLocationCheckBox;
	private EditText mLocationURL;
	private EditText mSettingURL;
	private CheckBox mDebugModeCheckBox;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		/** これをやらないと起動時にキーボードが表示されてしまう */
		this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
		
		setContentView(R.layout.location_settings);

		mApp = (ApplicationClass) getApplication();
		mSettings = mApp.getLocationSettings();

		mOK = (Button)findViewById(R.id.locationSettingOK);
		mSID = (EditText)findViewById(R.id.locationSID);
		mUID = (EditText)findViewById(R.id.locationUID);
		mAPPID = (EditText)findViewById(R.id.locationAPPID);
		mInterval = (EditText)findViewById(R.id.locationInterval);
		mGPSCheckBox = (CheckBox) findViewById(R.id.checkBox_gps);
		mNetworkCheckBox = (CheckBox) findViewById(R.id.checkBox_network);
		mDocomoCheckBox = (CheckBox) findViewById(R.id.checkBox_docomo);
		mSendLocationCheckBox = (CheckBox) findViewById(R.id.checkBox_sendLocation);
		mLocationURL = (EditText)findViewById(R.id.locationURL);
		mSettingURL = (EditText)findViewById(R.id.settingURL);
		mDebugModeCheckBox = (CheckBox) findViewById(R.id.checkBox_debug);

		mOK.setOnClickListener(this);

		mSID.setText(mSettings.getSID());
		mUID.setText(mSettings.getUID());
		mAPPID.setText(mSettings.getAPPID());
		mInterval.setText(mSettings.getInterval().toString());
		mGPSCheckBox.setChecked(false);
		mNetworkCheckBox.setChecked(false);
		mDocomoCheckBox.setChecked(false);
		mSendLocationCheckBox.setChecked(mSettings.getPermissionLocationHistory().equals("ON") ? true : false);
		mLocationURL.setText(mSettings.getLogServerURL()[0]);
		mSettingURL.setText(mSettings.getSettingServerURL());
		mDebugModeCheckBox.setChecked(mSettings.getDebugMode());

		String provider[] = mSettings.getProvider();
		for ( String priv : provider )
		{
			if ( priv == null ) continue;
			if ( priv.equals("GPS") )
				mGPSCheckBox.setChecked(true);
			if ( priv.equals("NETWORK") )
				mNetworkCheckBox.setChecked(true);
			if ( priv.equals("DOCOMO") )
				mDocomoCheckBox.setChecked(true);
		}
	}

	@Override
	public void onClick(View view)
	{
		switch (view.getId()) {
		case R.id.locationSettingOK:
			// 入力値を反映して画面終了
			String sid = mSID.getText().toString();
			mSettings.setSID(sid);

			String uid = mUID.getText().toString();
			mSettings.setUID(uid);

			String appid = mAPPID.getText().toString();
			mSettings.setAPPID(appid);

			Integer interval = null;
			try {
				interval = Integer.parseInt(mInterval.getText().toString());
			}
			catch (Exception e) {
			}
			if(interval == null || interval <= 0)
			{
				interval = 0;
			}
			mSettings.setInterval(interval);

		    String[] provider = null;
		    boolean isGPS = false;
		    boolean isNETWORK = false;
		    boolean isDOCOMO = false;
		    if (mGPSCheckBox.isChecked() == true)
		    {
		    	isGPS = true;
		    }
		    if (mNetworkCheckBox.isChecked() == true)
		    {
		    	isNETWORK = true;
		    }
		    if (mDocomoCheckBox.isChecked() == true)
		    {
		    	isDOCOMO = true;
		    }
	        if(isGPS && isNETWORK && isDOCOMO){
	        	provider = new String[3];
	        	provider[0] = "GPS";
	        	provider[1] = "NETWORK";
	        	provider[2] = "DOCOMO";
	        }else if(isGPS && isNETWORK && !isDOCOMO){
	        	provider = new String[2];
	        	provider[0] = "GPS";
	        	provider[1] = "NETWORK";
	        }else if(isGPS && !isNETWORK && isDOCOMO){
	        	provider = new String[2];
	        	provider[0] = "GPS";
	        	provider[1] = "DOCOMO";
	        }else if(!isGPS && isNETWORK && isDOCOMO){
	        	provider = new String[2];
	        	provider[0] = "NETWORK";
	        	provider[1] = "DOCOMO";
	        }else if(isGPS && !isNETWORK && !isDOCOMO){
	        	provider = new String[1];
	        	provider[0] = "GPS";
	        }else if(!isGPS && isNETWORK && !isDOCOMO){
	        	provider = new String[1];
	        	provider[0] = "NETWORK";
	        }else if(!isGPS && !isNETWORK && isDOCOMO){
	        	provider = new String[1];
	        	provider[0] = "DOCOMO";
	        }else{
	        	provider = new String[3];
	        	provider[0] = "GPS";
	        	provider[1] = "NETWORK";
	        	provider[2] = "DOCOMO";
	        }
		    mSettings.setProvider(provider);

			String locationURL = mLocationURL.getText().toString();
			mSettings.setPermissionLocationHistory(mSendLocationCheckBox.isChecked());
			mSettings.setLogServerURL(locationURL);

			String settingURL = mSettingURL.getText().toString();
			mSettings.setSettingServerURL(settingURL);
			mSettings.setDebugMode(mDebugModeCheckBox.isChecked());
			
			mSettings.saveToFile(getApplicationContext());

			finish();
			break;
		default:
			break;
		}
	}

}
