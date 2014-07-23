class Way < ActiveRecord::Base
	has_one :location

	validates :name, length: { maximum: 255 }, presence: true
end
