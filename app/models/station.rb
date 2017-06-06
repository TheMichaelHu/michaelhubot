class Station < ActiveRecord::Base
  has_many :stops
  has_many :routes, through: :stops
end
