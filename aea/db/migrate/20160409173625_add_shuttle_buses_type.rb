class AddShuttleBusesType < ActiveRecord::Migration
  def change
    add_column :shuttle_buses, :shuttle_bus_type, :string
  end
end
