# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170604145314) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "routes", force: true do |t|
    t.string "route_id"
    t.string "name"
    t.string "mode"
  end

  create_table "routes_stations", id: false, force: true do |t|
    t.integer "route_id"
    t.integer "station_id"
  end

  add_index "routes_stations", ["route_id"], name: "index_routes_stations_on_route_id", using: :btree
  add_index "routes_stations", ["station_id"], name: "index_routes_stations_on_station_id", using: :btree

  create_table "stations", force: true do |t|
    t.string "name"
  end

  create_table "stops", force: true do |t|
    t.integer "route_id"
    t.integer "station_id"
    t.string  "stop_id"
    t.string  "name"
    t.string  "direction_id"
    t.string  "direction_name"
  end

  add_index "stops", ["route_id"], name: "index_stops_on_route_id", using: :btree
  add_index "stops", ["station_id"], name: "index_stops_on_station_id", using: :btree

end
