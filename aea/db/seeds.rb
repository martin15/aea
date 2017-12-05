# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



country_1 = Country.find_or_create_by( :name => 'Singapore', :category_type => "Developed" )
country_2 = Country.find_or_create_by( :name => 'Malaysia', :category_type => "Developed" )
country_3 = Country.find_or_create_by( :name => 'Japan', :category_type => "Developed" )
country_4 = Country.find_or_create_by( :name => 'Korea', :category_type => "Developed" )
country_5 = Country.find_or_create_by( :name => 'Hong Kong', :category_type => "Developed" )
country_6 = Country.find_or_create_by( :name => 'Taiwan', :category_type => "Developed" )
country_7 = Country.find_or_create_by( :name => 'Australia', :category_type => "Developed" )
country_8 = Country.find_or_create_by( :name => 'New Zealand', :category_type => "Developed" )
country_9 = Country.find_or_create_by( :name => 'USA', :category_type => "Developed" )
country_10 = Country.find_or_create_by( :name => 'EU', :category_type => "Developed" )
country_10 = Country.find_or_create_by( :name => 'Indonesia', :category_type => "Developing" )


user_type_1 = UserType.find_or_create_by( :name => 'National Alliance' )
user_type_2 = UserType.find_or_create_by( :name => 'Leader and Member of AEA Commissions' )
user_type_3 = UserType.find_or_create_by( :name => 'AEA Executive Team Members' )
user_type_4 = UserType.find_or_create_by( :name => 'Partners & Observers' )
user_type_5 = UserType.find_or_create_by( :name => 'Representative of Local Leaders' )

user  = User.find_by_email("aeaga2016@gmail.com")
if user.nil?
  user_type_5 = User.create( :email => 'aeaga2016@gmail.com', :password => "30012016BDG",
                             :password_confirmation => "30012016BDG",
                             :first_name => "admin", :last_name => "admin",
                             :passport_number => "12345678", :age => "99",
                             :confirmed_at => Time.now, :country_id => country_10.id,
                             :user_type_id => user_type_5.id, :gender => 'male',
                             :title => "Mr")
end

user  = User.find_by_email("martin.me15@yahoo.com")
if user.nil?
  user_type_5 = User.create( :email => 'martin.me15@yahoo.com', :password => "1q2w3e4r5t",
                             :password_confirmation => "1q2w3e4r5t",
                             :first_name => "admin", :last_name => "admin",
                             :passport_number => "12345678", :age => "99",
                             :confirmed_at => Time.now, :country_id => country_10.id,
                             :user_type_id => user_type_5.id, :gender => 'male',
                             :title => "Mr")
end
user  = User.find_by_email("erdy@gmail.com")
if user.nil?
  user_type_5 = User.create( :email => 'erdy@gmail.com', :password => "12345678",
                             :password_confirmation => "12345678",
                             :first_name => "admin", :last_name => "admin",
                             :passport_number => "12345678", :age => "99",
                             :confirmed_at => Time.now, :country_id => country_10.id,
                             :user_type_id => user_type_5.id, :gender => 'male',
                             :title => "Mr")
end

room_type = UserType.find_or_create_by(:name => "Single Room")
room_type_2 = UserType.find_or_create_by(:name => "Twin Sharing Room")


area_name_1_a = AreaName.find_or_create_by(:name => "Front A")
area_name_1_b = AreaName.find_or_create_by(:name => "Front B")
area_name_1_c = AreaName.find_or_create_by(:name => "Front C")
area_name_1_d = AreaName.find_or_create_by(:name => "Front D")
area_name_2_a = AreaName.find_or_create_by(:name => "Back A")
area_name_2_b = AreaName.find_or_create_by(:name => "Back B")
area_name_2_c = AreaName.find_or_create_by(:name => "Back C")
area_name_3_a = AreaName.find_or_create_by(:name => "Balcony A")
area_name_3_b = AreaName.find_or_create_by(:name => "Balcony B")
area_name_4_a = AreaName.find_or_create_by(:name => "Outside")


["front", "back", "balcony", "other"].each do |name|
  (1..9).each do |x|
    email = "#{name}_#{x}@gmail.com"
    user  = User.find_by_email(email)
    if user.nil?
      user_type_5 = User.create( :email => email, :password => "#{name}12345",
                                 :password_confirmation => "#{name}12345",
                                 :first_name => name, :last_name => name,
                                 :passport_number => "12345678", :age => "99",
                                 :confirmed_at => Time.now, :country_id => country_10.id,
                                 :user_type_id => user_type_5.id, :gender => 'male',
                                 :title => "Mr")
    end
  end

end

