class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string  :name
      t.string  :category_type
      t.string  :permalink
      t.timestamps null: false
    end
  end
end
