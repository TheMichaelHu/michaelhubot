class CreateRoutesAndStops < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :route_id
      t.string :name
    end

    create_table :stops do |t|
      t.string :stop_id
      t.string :name
    end

    create_table :directions, id: false do |t|
      t.belongs_to :route, index: true
      t.belongs_to :stop, index: true
      t.string :direction_id
      t.string :name
    end
  end
end
