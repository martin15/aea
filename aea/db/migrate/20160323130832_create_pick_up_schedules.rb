class CreatePickUpSchedules < ActiveRecord::Migration
  def change
    create_table :pick_up_schedules do |t|
      t.date    :departing_date
      t.time    :departing_time
      t.string  :departing_flight_number
      t.string  :departing_airport
      t.date    :arriving_date
      t.time    :arriving_time
      t.string  :arriving_flight_number
      t.string  :arriving_airport
      t.string  :user_id
      t.timestamps null: false
    end
  end
end
