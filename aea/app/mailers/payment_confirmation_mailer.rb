class PaymentConfirmationMailer < ApplicationMailer

  def payment_confirmation_for_user(user, domain)
    @user = user
    @domain = domain
    mail(to: @user.email, subject: "[AEA GA 2016] Payment Confirmation") do |format|
      format.html
    end
  end

  def payment_confirmation_for_admin(user, domain)
    @user = user
    @domain = domain
    mail(to: ["aeaga2016@gmail.com", "martin.me15@yahoo.com"], subject: "[AEA GA 2016] Payment Confirmation - Admin") do |format|
      format.html
    end
  end
end
