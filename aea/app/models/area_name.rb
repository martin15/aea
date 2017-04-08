class AreaName < ActiveRecord::Base
  has_permalink :name, :update => true

  has_many :occupied_seats
end
