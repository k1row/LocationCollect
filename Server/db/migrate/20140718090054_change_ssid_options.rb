class ChangeSsidOptions < ActiveRecord::Migration
 def up
    change_column :locations, :ssid, :string, null: true, default: nil
  end

  def down
    change_column :locations, :ssid, :string, null: false
  end
end
