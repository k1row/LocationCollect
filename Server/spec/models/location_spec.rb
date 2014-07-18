require 'spec_helper'

describe Location do
	#describe '#ssid' do
	#	it { should validate_presence_of(:ssid) }
	#end

	describe '#bssid' do
		it { should validate_presence_of(:bssid) }
	end

	describe '#capabilities' do
		it { should validate_presence_of(:capabilities) }
	end

	describe '#level' do
		it { should validate_presence_of(:level) }
	end

	describe '#frequency' do
		it { should validate_presence_of(:frequency) }
	end

	describe '#accuracy' do
		it { should validate_presence_of(:accuracy) }
	end

	describe '#latitude' do
		it { should validate_presence_of(:latitude) }
	end

	describe '#longitude' do
		it { should validate_presence_of(:longitude) }
	end

	describe '#provider' do
		it { should validate_presence_of(:provider) }
	end

end
