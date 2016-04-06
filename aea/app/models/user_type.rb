class UserType < ActiveRecord::Base
  has_permalink :name, :update => true

  has_many :users
  has_many :room_types, :through => :room_types_user_types
  has_many :room_types_user_types
  def self.list
    self.all.map{|x| [x.name, x.id]}
  end

end
