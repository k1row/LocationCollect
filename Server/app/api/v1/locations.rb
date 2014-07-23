# -*- encoding: utf-8 -*-
module Locations
	class APIv1 < Grape::API
		format :json
		default_format :json

    rescue_from :all do |e|
      Rack::Response.new([ e.message ], 406, { "Content-type" => "application/json" }).finish
    end

    rescue_from ArgumentError do |e|
      Rack::Response.new([ "ArgumentError: #{e.message}" ], 406).finish
    end
    rescue_from NotImplementedError do |e|
      Rack::Response.new([ "NotImplementedError: #{e.message}" ], 406).finish
    end

    version "v1", using: :path

    resource :locations do
      get ':id' do
        Location.find(params[:id])
      end

      desc "returns all locaiton"
      get do
        Location.all
      end
      desc "entry new location"
      post do

        Location.create!({
          ssid: params[:ssid],
          bssid: params[:bssid],
          capabilities: params[:capabilities],
          level: params[:level],
          frequency: params[:frequency],
          accuracy: params[:accuracy],
          latitude: params[:latitude],
          longitude: params[:longitude],
          provider: params[:provider],
          device_id: params[:device_id],
          way_id: params[:way_id],
          speed: params[:speed],
          floor: params[:floor]
          })

        status 201  # 正常終了
      end
    end
  end
end
