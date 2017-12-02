class AreaNamesUser < ActiveRecord::Base
  belongs_to :area_name
  belongs_to :user
end
