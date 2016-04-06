class RoomType < ActiveRecord::Base

  has_many :users
  has_many :user_types, :through => :room_types_user_types
  has_many :room_types_user_types

  def price_for(user_type, type)
    return 0 if self.id.nil?
    room_types_price = RoomTypesUserType.where("user_type_id = #{user_type.id} and 
                                                room_type_id = #{self.id} and
                                                country_type = '#{type}'").first
    if room_types_price.nil?
      return 0
    else
      return room_types_price.price
    end
  end

  def price_for_indonesia
    return 0 if self.id.nil?
    room_types_price = RoomTypesUserType.where("room_type_id = #{self.id} and
                                                country_type = 'indonesia'").first
    return room_types_price.nil? ? 0 : room_types_price.price
  end
end
