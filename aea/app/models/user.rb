class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :skip_password_validation

  has_one :pick_up_schedule
  has_many :members, :class_name => "User", :foreign_key => :leader_id

  belongs_to :team_leader, :class_name => "User", :foreign_key => :leader_id

  belongs_to :country
  belongs_to :room_type
  belongs_to :user_type

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :passport_number, :presence => true
  validates :age, :presence => true, :numericality => true

  def full_name
    "#{self.try(:first_name)} #{self.try(:last_name)}"
  end

  def is_team_lead?
    self.user_type.name == "National Alliance"
  end

  def is_admin?
    self.email == "aeaga2016@gmail.com" || self.email == "martin.me15@yahoo.com"
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
