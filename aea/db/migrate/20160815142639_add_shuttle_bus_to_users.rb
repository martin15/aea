class AddShuttleBusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :arriving_id, :integer
    add_column :users, :departing_id, :integer
  end
end
