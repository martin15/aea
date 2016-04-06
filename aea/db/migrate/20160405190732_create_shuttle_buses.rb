class CreateShuttleBuses < ActiveRecord::Migration
  def change
    create_table :shuttle_buses do |t|
      t.string    :name
      t.date      :pick_up_date
      t.time      :pick_up_time
      t.string    :airport_name
      t.string    :note
      t.timestamps null: false
    end
  end
end
