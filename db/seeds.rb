# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
    route_obj = Route.create(route_id: route["route_id"], name: route["route_name"])

    stops = make_request("http://realtime.mbta.com/developer/api/v2/stopsbyroute?api_key=#{ENV["MBTA_KEY"]}&route=#{route["route_id"]}&format=json")
    stops["direction"].each do |direction|
      stops_list = direction["stop"]
      stops_list.each do |stop|
        stop_obj = Stop.where(stop_id: stop["stop_id"], name: stop["stop_name"]).first_or_create
        Direction.create(route: route_obj, stop: stop_obj, direction_id: direction["direction_id"], name: direction["direction_name"])
      end
    end
  end
end