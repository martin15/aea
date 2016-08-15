class ShuttleBus < ActiveRecord::Base
  has_many :users

  def self.arriving_list
    ShuttleBus.where("shuttle_bus_type = 'arriving'")
  end

  def self.departing_list
    ShuttleBus.where("shuttle_bus_type = 'departing'")
  end

end
