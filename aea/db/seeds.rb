# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



country_1 = Country.find_or_create_by_name( :name => 'Singapore', :country_type => "Developed" )
country_2 = Country.find_or_create_by_name( :name => 'Malaysia', :country_type => "Developed" )
country_3 = Country.find_or_create_by_name( :name => 'Japan', :country_type => "Developed" )
country_4 = Country.find_or_create_by_name( :name => 'Korea', :country_type => "Developed" )
country_5 = Country.find_or_create_by_name( :name => 'Hong Kong', :country_type => "Developed" )
country_6 = Country.find_or_create_by_name( :name => 'Taiwan', :country_type => "Developed" )
country_7 = Country.find_or_create_by_name( :name => 'Australia', :country_type => "Developed" )
country_8 = Country.find_or_create_by_name( :name => 'New Zealand', :country_type => "Developed" )
country_9 = Country.find_or_create_by_name( :name => 'USA', :country_type => "Developed" )
country_10 = Country.find_or_create_by_name( :name => 'EU', :country_type => "Developed" )
country_10 = Country.find_or_create_by_name( :name => 'Indonesia', :country_type => "Developing" )


user_type_1 = UserType.find_or_create_by_name( :name => 'National Alliance' )
user_type_2 = UserType.find_or_create_by_name( :name => 'Leader and Member of AEA Commissions' )
user_type_3 = UserType.find_or_create_by_name( :name => 'AEA Executive Team Members' )
user_type_4 = UserType.find_or_create_by_name( :name => 'Partner & Observers' )
user_type_5 = UserType.find_or_create_by_name( :name => 'Representative of Local Leaders' )

user_type_5 = User.find_or_create_by_email( :email => 'aeaga2016@gmail.com', :password => "30012016BDG",
                                            :password_confirmation => "30012016BDG",
                                            :first_name => "admin", :last_name => "admin",
                                            :passport_number => "12345678", :age => "99",
                                            :confirmed_at => Time.now, :country_id => country_10.id,
                                            :user_type_id => user_type_5.id, :gender => 'male',
                                            :title => "Mr")

