class CreateAreaNamesUsers < ActiveRecord::Migration
  def change
    create_table :area_names_users do |t|
      t.string  :user_id
      t.string  :area_name_id
      t.timestamps null: false
    end
  end
end
