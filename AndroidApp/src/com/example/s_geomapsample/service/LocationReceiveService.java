package com.example.s_geomapsample.service;

import java.util.Date;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.widget.Toast;

public class LocationReceiveService extends Service {

	private Handler handler;
	private LocationReceiveService context;

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	public void registerHandler(Handler UpdateHandler) {
		handler = UpdateHandler;
	}

	public synchronized void sleep(long msec) {
		try {
			wait(msec);
		} catch (InterruptedException e) {
		}
	}

	protected void sendBroadCast(Intent intent) {
		Intent broadcastIntent = new Intent();

		double latitude = intent.getDoubleExtra("Latitude", 0);
		float accuracy = intent.getFloatExtra("Accuracy", 0);
		double longitude = intent.getDoubleExtra("Longitude", 0);
		String provider = intent.getStringExtra("Provider");
		Date date = (Date) intent.getSerializableExtra("Date");

		System.out.println("Latitude = " + latitude + "\nAccuracy = " + accuracy + "\nLongitude = " + longitude
				+ "\nProvider = " + provider + "\nDate = " + date);

		broadcastIntent.putExtra("Latitude", latitude);
		broadcastIntent.putExtra("Accuracy", accuracy);
		broadcastIntent.putExtra("Longitude", longitude);
		broadcastIntent.putExtra("Provider", provider);
		broadcastIntent.putExtra("Date", date);
		broadcastIntent.setAction("UPDATE_ACTION");
		getBaseContext().sendBroadcast(broadcastIntent);

		Toast.makeText(this, "Latitude = " + latitude + "\nAccuracy = " + accuracy + "\nLongitude = " + longitude
				+ "\nProvider = " + provider + "\nDate = " + date, Toast.LENGTH_LONG).show();

	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		int startFlag = super.onStartCommand(intent, flags, startId);
		if (intent == null) {
			return startFlag;
		}

		String information = intent.getStringExtra("Information");
		if ((information != null) && (information.equals("Measure") == true)) {
			sendBroadCast(intent);
		}

		return startFlag;
	}
}
