class ShuttleBus < ActiveRecord::Base
  #has_many :users

  def self.arriving_list
    ShuttleBus.where("shuttle_bus_type = 'arriving'")
  end

  def self.departing_list
    ShuttleBus.where("shuttle_bus_type = 'departing'")
  end

  def users
    if self.shuttle_bus_type == "arriving"
      User.where("arriving_id = #{self.id} ")
    else
      User.where("departing_id = #{self.id} ")
    end
  end
end
