class Country < ActiveRecord::Base
  has_permalink :name, :update => true

  has_many :users
  def self.list
    self.order(:name).map{|x| [x.name, x.id]}
  end
end
