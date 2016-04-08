class AddStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, :default => "Pending"
    add_column :users, :approved_at, :datetime
    add_column :users, :registration_number, :string
  end
end
