class CreatePaymentConfirmations < ActiveRecord::Migration
  def change
    create_table :payment_confirmations do |t|
      t.string    :payment_method
      t.string    :sender_name
      t.integer  :amount
      t.date      :payment_date
      t.integer    :user_id
      t.timestamps null: false
    end
  end
end
