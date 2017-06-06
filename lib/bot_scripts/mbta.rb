require 'fuzzy_match'
require 'net/http'

module MBTA
  include Sender
  
  def self.hear(sender, message)
    terms = /n..?t ([a-zA-Z]* (?:bus|line) [a-zA-Z]*) f..?m ([a-zA-Z ]*)/i.match(message).to_a

    if terms && terms.length > 2
      parser = MbtaParser.new
      route, stop = parser.parse_mbta_terms(terms.last(2))
      return false if route.nil? || stop.nil?

      Sender.send_message(sender, parser.generate_message(route, stop))
      return true
    end
    return false
  end

  class MbtaParser
    def parse_mbta_terms(terms)
      route, stop = terms
      route_id = parse_route(route)
      return [route_id, parse_stop(route_id, stop)]
    end

    def generate_message(route, stop)
      next_routes = [0, 1].map do |direction|
        uri = URI.parse("http://realtime.mbta.com/developer/api/v2/schedulebystop?api_key=#{ENV['MBTA_KEY']}&route=#{route}&stop=#{stop}&direction=#{direction}&max_trips=1&format=json")

        response = JSON.parse(Net::HTTP.get_response(uri).body)

        arrival_time = response.dig("mode", 0, "route", 0, "direction", 0, "trip", 0, "sch_arr_dt")

        if arrival_time.nil?
          ""
        else
          time = Time.at(arrival_time.to_i).strftime("%I:%M %p")
          "#{response["stop_name"]} at #{time}"
        end
      end

      if next_routes.join('').empty?
        return "No routes available for #{response["stop_name"]}!"
      end

      return next_routes.join("\n")
    end

    private

    def parse_route(route)
      possible_routes = Route.all

      return nil if possible_routes.empty?
      best_match = FuzzyMatch.new(possible_routes.map(&:name)).find(route)

      return Route.find_by(name: best_match).route_id
    end

    def parse_stop(route_id, stop)
      return nil if route_id.nil?
      possible_stops = Stop.joins(:routes).where(routes: {route_id: route_id})

      return nil if possible_stops.empty?
      best_match = FuzzyMatch.new(possible_stops.map(&:name)).find(stop)

      return Stop.find_by(name: best_match).stop_id
    end
  end
end