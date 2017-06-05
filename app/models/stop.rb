class Stop < ActiveRecord::Base
  has_many :directions
  has_many :routes, through: :directions
end
