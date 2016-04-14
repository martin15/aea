class PaymentConfirmation < ActiveRecord::Base
  belongs_to :user

  validates :sender_name, :presence => true
  validates :amount, :presence => true, :numericality => true
  validates :payment_date, :presence => true

end
