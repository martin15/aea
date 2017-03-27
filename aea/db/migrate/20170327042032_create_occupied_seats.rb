class CreateOccupiedSeats < ActiveRecord::Migration
  def change
    create_table :occupied_seats do |t|
      t.integer     :area_name_id
      t.string      :column_name
      t.string      :seat_coordinate
      t.string      :status
      t.timestamps null: false
    end
  end
end
