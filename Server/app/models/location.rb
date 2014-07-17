class Location < ActiveRecord::Base

	validates :ssid, presence: true                                # APのMACアドレス
	validates :bssid, presence: true                               # APのネットワーク名
	validates :capabilities, presence: true                        # APの暗号化情報
	validates :level, presence: true                               # APの信号レベル(dBm)
	validates :frequency, presence: true                           # APのチャンネル周波数(MHz)
	validates :accuracy, presence: true                            # 位置情報の精度
	validates :latitude, length: { maximum: 10 }, presence: true   # 緯度
	validates :longitude, length: { maximum: 10 }, presence: true  # 経度
	validates :provider, presence: true                            # 位置情報の取得先 gps network

end
