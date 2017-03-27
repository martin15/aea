class CreateAreaNames < ActiveRecord::Migration
  def change
    create_table :area_names do |t|
      t.string    :name
      t.integer   :main_column
      t.integer   :total_row
      t.integer   :seats_per_row
      t.boolean   :status
      t.string    :permalink
      t.timestamps null: false
    end
  end
end
