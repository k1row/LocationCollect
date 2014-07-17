package com.example.s_geomapsample.sample;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;
import java.util.HashMap;

import android.content.Context;

/**
 * HashMapを保持するクラス
 * @author kazuya
 *
 */
public abstract class InfoDataModel {
	protected static HashMap<String, String> myHash =  new HashMap<String, String>();

	/**
	 *	デフォルトの辞書を返す
	 * */
	abstract HashMap<String, String> getDefault();

	/**
	 *	値を設定する
	 * @return 
	 * */
	public void putValue(String key, String value) {
		myHash.put(key, value);
	}

	/**
	 *	値を取得する
	 * */
	public String getValue(String key) {
		return myHash.get(key);
	}

	/**
	 *	値を削除する
	 * */
	public String removeValue(String key) {
		return myHash.remove(key);
	}

	/**
	 *	デフォルトの状態に戻す
	 * */
	public void backToDefault() {
		myHash.clear();
		myHash.putAll(getDefault());
	}

	/**
	 *	myHashを保存する
	 * */
	public Boolean saveToFile(String fileName) {
		Boolean didSaved = false;
		try {
			Context context = ApplicationClass.getAppContext();
			FileOutputStream fos = context.openFileOutput(fileName, Context.MODE_PRIVATE);
			ObjectOutputStream oos = new ObjectOutputStream(fos);
			oos.writeObject(myHash);
			didSaved = true;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return didSaved;
	}

	/**
	 *	myHashをファイルから読み込む
	 * */
	@SuppressWarnings("unchecked")
	public Boolean loadFromFile(String fileName) {
		Boolean didLoaded = false;

		HashMap<String, String> loadHash = null;
		try {
			Context context = ApplicationClass.getAppContext();
			FileInputStream fis = context.openFileInput(fileName);
			ObjectInputStream ois = new ObjectInputStream(fis);
			loadHash = (HashMap<String, String>) ois.readObject();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (StreamCorruptedException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		if ( loadHash != null ) {
			myHash = loadHash;
			didLoaded = true;
		}

		return didLoaded;
	}
}
