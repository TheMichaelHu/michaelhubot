class CreateRoutesAndStops < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :route_id
      t.string :name
      t.string :mode
    end

    create_table :stations do |t|
      t.string :name
    end

    create_table :stops do |t|
      t.belongs_to :route, index: true
      t.belongs_to :station, index: true
      t.string :stop_id
      t.string :name
      t.string :direction_id
      t.string :direction_name
    end
  end
end
