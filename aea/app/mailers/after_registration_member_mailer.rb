class AfterRegistrationMemberMailer < ApplicationMailer

def after_registration_member_for_user(user, domain)
    @user = user
    @domain = domain
    mail(to: @user.email, subject: "[AEA GA 2016] Registration") do |format|
      format.html
    end
  end

  def after_registration_member_for_admin(user, domain)
    @user = user
    @domain = domain
    mail(to: ["aeaga2016@gmail.com", "martin.me15@yahoo.com"], subject: "[AEA GA 2016] Registration - Admin") do |format|
      format.html
    end
  end
end
