class RoomTypesUserType < ActiveRecord::Base
  belongs_to :room_type
  belongs_to :user_type
end
