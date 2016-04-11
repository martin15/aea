class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :skip_password_validation

  has_one :pick_up_schedule
  has_one :ticket
  has_many :members, :class_name => "User", :foreign_key => :leader_id
  has_many :payment_confirmations

  belongs_to :team_leader, :class_name => "User", :foreign_key => :leader_id

  belongs_to :country
  belongs_to :room_type
  belongs_to :user_type

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :passport_number, :presence => true
  validates :age, :presence => true, :numericality => true

  def full_name
    "#{self.try(:title)} #{self.try(:first_name)} #{self.try(:last_name)}"
  end

  def is_team_lead?
    return false if self.user_type.nil?
    return self.user_type.name == "National Alliance"
  end

  def is_admin?
    self.email == "aeaga2016@gmail.com" || self.email == "martin.me15@yahoo.com"
  end

  def is_indonesian?
    self.country == Country.find_by_name("Indonesia")
  end

  def payment_method_is_transfer_bank?
    self.payment_type == "bank_bca"
  end

  def get_registration_number
    user_type = ''
    case self.user_type.name
      when 'National Alliance'
        user_type = "NA"
      when 'Leader and Member of AEA Commissions'
        user_type = "AC"
      when 'AEA Executive Team Members'
        user_type = "AE"
      when 'Partners & Observers'
        user_type = "PO"
      when 'Representative of Local Leaders'
        user_type = "LL"
    end

    country_type = self.country.category_type == "Developed" ? "M" : "B"
    month = Date.today.try(:strftime, "%m")
    users_total = User.where("approved_at >= ? AND approved_at <= ?",
                       Date.today.at_beginning_of_month, Date.today.at_end_of_month).size

    return "#{user_type}#{country_type}#{month}#{(users_total+1).to_s.rjust(3, '0')}"
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
