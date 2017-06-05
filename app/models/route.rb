class Route < ActiveRecord::Base
  has_many :directions
  has_many :stops, through: :directions
end
