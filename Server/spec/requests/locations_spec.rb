# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Endpoint::API do

	# 有効なファクトリを持つこと
	it "has a valid factory" do
		expect(FactoryGirl.build(:location)).to be_valid
	end

	describe 'Location' do

		describe 'GET /api/v1/locations', autodoc: true do
			before do
				@params = FactoryGirl.build(:location)
				get "/api/v1/locations/#{@params.id}"
			end

			it '登録されている情報を取得できる' do
				expect(response).to be_success
				expect(response.status).to eq(200)
			end
		end

		describe 'POST /api/v1/locations', autodoc: true do

			let(:path) {'/api/v1/locations'}

			context '正常な投稿' do
				before do
					@params = FactoryGirl.attributes_for(:location)
				end

				it 'Locationデータを新たに登録できる' do
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					expect(response).to be_success
					expect(response.status).to eq(201)
				end

				it 'locationsデータが１増える' do
					expect {
						post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
						}.to change(Location, :count).by(1)
				end
			end
		end

		context 'SSIDが入っていない時' do

			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, ssid: '')
			end

			it 'Locationデータを新たに登録できる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).to be_success
				expect(response.status).to eq(201)
			end

			it 'locationsデータが１増える' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.to change(Location, :count).by(1)
 			end
		end

		context 'BSSIDが入っていない時' do

			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, bssid: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Bssidを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'Latitudeが入っていない時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, latitude: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Latitudeを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'Longitudeが入っていない時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, longitude: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Longitudeを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'device_idが入っていない時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, device_id: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Deviceを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'way_idが入っていない時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, way_id: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Wayを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

=begin
		context '定義されていないway_idが来た時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, way_id: 115)
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Wayを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end
=end

		context 'speedが入っていない時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, speed: '')
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Speedは数値で入力してください。, Speedは一覧にありません。, Speedを入力してください。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'speedがマイナス時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, speed: -10)
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Speedは一覧にありません。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'speedが100を超えている時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, speed: 101)
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Speedは一覧にありません。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

		context 'floorが-2以下の時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, floor: -4)
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Floorは一覧にありません。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end


		context 'floorが23以上の時' do
			let(:path) {'/api/v1/locations'}

			before do
				@params = FactoryGirl.attributes_for(:location, floor: 40)
			end

			it '500 が返ってくる' do
				post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
				expect(response).not_to be_success
				expect(response.status).to eq(500)
			  expect(response.body).to eq('バリデーションに失敗しました。 Floorは一覧にありません。')
			end

			it 'locationsデータは増減しない' do
				expect {
					post path, @params.to_json, 'CONTENT_TYPE' => 'application/json, Accept-Version:v1'
					}.not_to change(Location, :count)
 			end
		end

	end

	describe 'PUT /api/v1/locations' do
		before do
			@params = FactoryGirl.build(:location)
			put "/api/v1/locations/#{@params.id}"
		end

		it 'FALSEが返ってくる' do
			expect(response).not_to be_success
			expect(response.status).to eq(404)
		end
	end
end

