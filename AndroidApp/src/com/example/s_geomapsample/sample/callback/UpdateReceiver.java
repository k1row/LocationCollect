package com.example.s_geomapsample.sample.callback;

import java.util.Date;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

/* Receiver内*/
public class UpdateReceiver extends BroadcastReceiver {

	public static Handler handler;

	@Override
	public void onReceive(Context context, Intent intent) {

		Bundle bundle = intent.getExtras();

		double latitude = bundle.getDouble("Latitude");
		float accuracy = bundle.getFloat("Accuracy");
		double longitude = bundle.getDouble("Longitude");
		Date date = (Date) intent.getSerializableExtra("Date");
		String provider = bundle.getString("Provider");

		
		
		if (handler != null) {
			Message msg = new Message();
			Bundle data = new Bundle();

			data.putDouble("latitude", latitude);
			data.putFloat("accuracy", accuracy);
			data.putDouble("longitude", longitude);
			data.putString("Provider", provider);
//			data.put
			
			
			msg.setData(data);
			handler.sendMessage(msg);
		}
	}

	/**
	 * メイン画面の表示を更新
	 */
	public void registerHandler(Handler locationUpdateHandler) {
		handler = locationUpdateHandler;
	}

}