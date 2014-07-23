class AddColumnToLocation < ActiveRecord::Migration
 def change
 	  add_column :locations, :device_id, :string, limit: 255, null: false, after: :provider
    add_column :locations, :way_id, :int, null: false, after: :device_id
    add_column :locations, :speed, :int, null: false, after: :way_id
    add_column :locations, :floor, :int, null: false, default: 0, after: :speed
    remove_index :locations, [:ssid, :bssid, :level]
    add_index :locations, [:ssid, :bssid]
  end
end
