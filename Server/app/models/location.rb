class Location < ActiveRecord::Base

  belongs_to :way

	validates :ssid, length: { maximum: 255 }, allow_blank: true       # APのMACアドレス
	validates :bssid, length: { maximum: 255 }, presence: true         # APのネットワーク名
	validates :capabilities, length: { maximum: 255 }, presence: true  # APの暗号化情報
	validates :level, length: { maximum: 255 }, presence: true         # APの信号レベル(dBm)
	validates :frequency, length: { maximum: 255 }, presence: true     # APのチャンネル周波数(MHz)
	validates :accuracy, length: { maximum: 255 }, presence: true      # 位置情報の精度
	validates :latitude, length: { maximum: 255 }, presence: true      # 緯度
	validates :longitude, length: { maximum: 255 }, presence: true     # 経度
	validates :provider, length: { maximum: 255 }, presence: true      # 位置情報の取得先 gps network
  validates :device_id, length: { maximum: 255 }, presence: true     # データ送信端末ID
  validates :way_id, presence: true
  validates :speed, numericality: true, inclusion: {in: 0..100 }, presence: true
  validates :floor, numericality: true, inclusion: {in: -2..23 }, allow_blank: true

end
