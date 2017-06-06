require 'fuzzy_match'
require 'net/http'

module MBTA
  include Sender
  
  def self.hear(sender, message)
    terms = /n..?t (.* (line|bus).*) f..?m ([a-zA-Z ]*)/i.match(message).to_a

    if terms && terms.length > 3
      parser = MbtaParser.new
      route, station = parser.parse_mbta_terms(terms.last(3))

      return false if route.nil? || station.nil?

      Sender.send_message(sender, parser.generate_message(route, station))
      return true
    end
    return false
  end

  class MbtaParser
    def parse_mbta_terms(terms)
      route, mode, station = terms
      route_obj = parse_route(route, mode)
      return [route_obj, parse_station(route_obj.route_id, station)]
    end

    def generate_message(route, station)
      next_routes = Stop.where(route: route, station: station).map do |stop|
        uri = URI.parse("http://realtime.mbta.com/developer/api/v2/schedulebystop?api_key=#{ENV['MBTA_KEY']}&route=#{route.route_id}&stop=#{stop.stop_id}&direction=#{stop.direction_id}&max_trips=1&format=json")

        response = JSON.parse(Net::HTTP.get_response(uri).body)

        arrival_time = response.dig("mode", 0, "route", 0, "direction", 0, "trip", 0, "sch_arr_dt")

        if arrival_time.nil?
          "No routes available for #{response["stop_name"]}!"
        else
          time = Time.at(arrival_time.to_i).strftime("%I:%M %p")
          "#{response["stop_name"]} at #{time}"
        end
      end

      return next_routes.join("\n")
    end

    private

    def parse_route(route, mode)
      if mode == "line"
        possible_routes = Route.where(mode: "Subway")
      elsif mode == "bus"
        possible_routes = Route.where(mode: "Bus")
      else
        possible_routes = Route.where(mode: ["Commuter Rail", "Boat"])
      end

      return nil if possible_routes.empty?
      best_match = FuzzyMatch.new(possible_routes.map(&:name)).find(route)

      return Route.find_by(name: best_match)
    end

    def parse_station(route_id, station)
      return nil if route_id.nil?
      possible_stations = Station.joins(:routes).where(routes: {route_id: route_id})

      return nil if possible_stations.empty?
      best_match = FuzzyMatch.new(possible_stations.map(&:name)).find(station)

      return Station.find_by(name: best_match)
    end
  end
end