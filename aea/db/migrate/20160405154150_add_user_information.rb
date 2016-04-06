class AddUserInformation < ActiveRecord::Migration
  def change
    add_column :users, :title,            :string
    add_column :users, :passport_number,  :string
    add_column :users, :roomate,          :string
    add_column :users, :age,              :integer
    add_column :users, :note,             :text
  end
end
