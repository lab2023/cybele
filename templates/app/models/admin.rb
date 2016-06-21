class Admin < ActiveRecord::Base
  # Virtual attributes
  attr_accessor :is_generated_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :async,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # Validations
  validates_presence_of :name, :email
  validates :email, uniqueness: true

  # Callbacks
  after_commit :send_login_info, on: :create
  before_validation :create_password, on: :create
  after_initialize do |obj|
    obj.is_generated_password = false
  end

  def active_for_authentication?
    super && self.is_active
  end

  def inactive_message
    I18n.t('devise.session.deactivated')
  end

  def full_name
    "#{self.name}"
  end

  private

  def create_password
    if self.password.nil?
      password                    = Devise.friendly_token.first(8)
      self.password               = password
      self.password_confirmation  = password
      self.is_generated_password  = true
    end
  end

  def send_login_info
    AdminMailer.send_login_information(self.id, self.password).deliver_later! if self.is_generated_password
  end

end
