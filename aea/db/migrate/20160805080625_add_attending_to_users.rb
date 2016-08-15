class AddAttendingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :attending, :boolean, :default => false
  end
end
