class ShuttleBus < ActiveRecord::Base
  #has_many :users

  validates :name, :presence => true
  validates :pick_up_date, :presence => true
  validates :pick_up_time, :presence => true
  validates :airport_name, :presence => true

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
