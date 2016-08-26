class AccommodationInfo < ApplicationMailer

  def accommodation_info_for_user(user, domain)
    @user = user
    @pu = user.pick_up_schedule
    @arriving_time = user.arriving_time
    @domain = domain
    attachments['AEA_GA_2016.pdf'] = File.read('public/AEA_GA_2016.pdf')
    mail(to: @user.email, subject: "[AEA GA 2016] ACCOMMODATION") do |format|
      format.html
    end
  end

  def accommodation_info_for_admin(user, domain)
    @user = user
    @pu = user.pick_up_schedule
    @arriving_time = user.arriving_time
    @domain = domain
    attachments['AEA_GA_2016.pdf'] = File.read('public/AEA_GA_2016.pdf')
    mail(to: ["aeaga2016@gmail.com", "martin.me15@yahoo.com"], subject: "[AEA GA 2016] ACCOMMODATION - Admin") do |format|
      format.html
    end
  end
end
