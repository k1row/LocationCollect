# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
  	sequence(:ssid) {|n|"LILO5056#{n}#{n}#{n}"}
  	sequence(:bssid) {|n|"#{n}#{n}:#{n}#{n}:#{n}#{n}:#{n}#{n}:#{n}#{n}"}
  	capabilities "aaaaaaaaaa"
  	sequence(:level) {|n|"4#{n}"}
  	sequence(:frequency) {|n|"1#{n}"}
  	sequence(:accuracy) {|n|"#{n}"}
  	latitude "35.3929"
  	longitude "139.4155"
  	provider "network"
  end
end
