class UserType < ActiveRecord::Base
  has_permalink :name, :update => true

  has_many :users
  has_many :room_types, :through => :room_types_user_types
  has_many :room_types_user_types

  def self.list_valid_type
    self.where("permalink != 'representative-of-local-leaders'")
  end

  def self.single_room
    where("name like '%Single Room%'")
  end

end
