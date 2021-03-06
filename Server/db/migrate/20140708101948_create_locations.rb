class CreateLocations < ActiveRecord::Migration
	def change
		create_table :locations do |t|
			t.string :ssid, limit: 255, null: false
			t.string :bssid, limit: 255, null: false
			t.string :capabilities, limit: 255, null: false
			t.string :level, limit: 255, null: false
			t.string :frequency, limit: 255, null: false
			t.string :accuracy, limit: 255, null: false
			t.string :latitude, limit: 255, null: false
			t.string :longitude, limit: 255, null: false
			t.string :provider, limit: 255, null: false
			t.timestamps null: false
		end
		add_index :locations, [:ssid, :bssid, :level], unique: true
	end
end
