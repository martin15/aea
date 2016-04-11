class PickUpSchedule < ActiveRecord::Base
  belongs_to :user

  validates :arriving_date, :presence => true
  validates :arriving_time, :presence => true
  validates :arriving_flight_number, :presence => true
  validates :arriving_airport, :presence => true
  validates :departing_date, :presence => true
  validates :departing_time, :presence => true
  validates :departing_flight_number, :presence => true
  validates :departing_airport, :presence => true

end
