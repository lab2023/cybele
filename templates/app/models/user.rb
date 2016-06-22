class User < ActiveRecord::Base
  # Virtual attributes
  attr_accessor :is_generated_password

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :async,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # Helpers
  audited except: [:password]

  # Validations
  validates_presence_of :name, :email, :surname
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

  def full_name
    "#{self.name} #{self.surname}"
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
    UserMailer.login_info(self.id, self.password).deliver_later! if self.is_generated_password
  end
end
