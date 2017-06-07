# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'net/http'

def make_request(url)
  uri = URI.parse(url)

  res = Net::HTTP.get_response(uri)
  return JSON.parse(res.body)
end

routes = make_request("http://realtime.mbta.com/developer/api/v2/routes?api_key=#{ENV["MBTA_KEY"]}&format=json")

routes["mode"].each do |mode|
  routes_list = mode["route"]
  routes_list.each do |route|
    puts route["route_name"]
    route_obj = Route.create(route_id: route["route_id"], name: route["route_name"], mode: mode["mode_name"])

    stops = make_request("http://realtime.mbta.com/developer/api/v2/stopsbyroute?api_key=#{ENV["MBTA_KEY"]}&route=#{route["route_id"]}&format=json")
    stops["direction"].each do |direction|
      stops_list = direction["stop"]
      stops_list.each do |stop|
        station_name = stop["stop_name"]
        if mode["mode_name"] == "Subway"
          station_name = /^([^-]*) - .*$/.match(stop["stop_name"]).to_a.dig(1) || station_name
        elsif mode["mode_name"] == "Bus"
          station_name = /^[^@]* @ (.*)$/.match(stop["stop_name"]).to_a.dig(1) || station_name
        end
        station_obj = Station.where(name: station_name).first_or_create

        stop_obj = Stop.create(route_id: route_obj.id, station_id: station_obj.id, stop_id: stop["stop_id"], name: stop["stop_name"], direction_id: direction["direction_id"], direction_name: direction["direction_name"])
      end
    end
  end
end

