package com.example.s_geomapsample;

import jp.co.zdc.geofencelib.GeoFenceManager;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.widget.Toast;

/**
 * 通知条件、エリア情報取得・更新処理
 */
public class UpdateAreaAsync extends AsyncTask<Object, Integer, Integer> {
	private ProgressDialog progressDialog = null;
	private Activity mActivity;
	private GeoFenceManager mGeoFenceManager;

	/**
	 * コンストラクタ
	 * 
	 * @param geoFenceManager
	 */
	public UpdateAreaAsync(Activity activity, GeoFenceManager geoFenceManager) {
		this.mActivity = activity;
		this.mGeoFenceManager = geoFenceManager;
	}

	/** タスク開始前処理：UIスレッドで実行される */
	@Override
	protected void onPreExecute() {
		/** ダイアログ表示 */
		progressDialog = new ProgressDialog(this.mActivity);
		progressDialog.setMessage("更新中...");
		progressDialog.setIndeterminate(false);
		progressDialog.setCancelable(true);
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		// progressDialog.show();
	}

	/** スレッドで実行する処理 */
	@Override
	protected Integer doInBackground(Object... params) {
		return mGeoFenceManager.updateAreaInfomation();
	}

	/** タスク終了後処理：UIスレッドで実行する処理 */
	@Override
	protected void onPostExecute(Integer result) {

		if (result == GeoFenceManager.UPDARE_RESULT_CODE_SUCCESS) {
			Toast.makeText(this.mActivity, "updateAreaInfomation result : success", Toast.LENGTH_SHORT).show();
		} else if (result == GeoFenceManager.UPDARE_RESULT_CODE_SERVER_ERROR) {
			Toast.makeText(this.mActivity, "updateAreaInfomation result : server error", Toast.LENGTH_SHORT).show();
		} else if (result == GeoFenceManager.UPDARE_RESULT_CODE_SERVER_DATA_ERROR) {
			Toast.makeText(this.mActivity, "updateAreaInfomation result : server data error", Toast.LENGTH_SHORT)
					.show();
		} else if (result == GeoFenceManager.UPDARE_RESULT_CODE_CONNECTION_ERROR) {
			Toast.makeText(this.mActivity, "updateAreaInfomation result : connection error", Toast.LENGTH_SHORT).show();
		} else if (result == GeoFenceManager.UPDARE_RESULT_CODE_UNAUTHORIZED) {
			Toast.makeText(this.mActivity, "updateAreaInfomation result : Authentication error", Toast.LENGTH_SHORT)
					.show();
		}
	}
}
