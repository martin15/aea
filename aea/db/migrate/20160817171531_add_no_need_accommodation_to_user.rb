class AddNoNeedAccommodationToUser < ActiveRecord::Migration
  def change
    add_column :users, :need_accomodation, :boolean, :default => true
  end
end
