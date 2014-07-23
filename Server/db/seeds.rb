# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_data_dir = "#{Rails.root}/db/data"

AdminUser.create(email: 'admin@airtrack.jp', password: 'airtrack', password_confirmation: 'airtrack')


# Timezone
seed_data = YAML.load_file("#{seed_data_dir}/ways.yml")
seed_data["master_data"].each do |mst|
  s = Way.find_or_initialize_by(id: mst["id"])
  s.id    = mst["id"]
  s.name  = mst["name"]
  s.save!
end
