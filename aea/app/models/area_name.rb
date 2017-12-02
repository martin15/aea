class AreaName < ActiveRecord::Base
  has_permalink :name, :update => true

  has_many :occupied_seats
  has_many :users, :through => :area_names_users
  has_many :area_names_users
end
