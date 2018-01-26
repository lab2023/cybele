# frozen_string_literal: true

class User < ApplicationRecord
  include PasswordCreatable

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  # Send devise emails with background job
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # Helpers
  audited except: [:password]

  # Validations
  validates_presence_of :name, :email, :surname
  validates :email, uniqueness: true

  def active_for_authentication?
    super && is_active
  end

  def full_name
    "#{name} #{surname}"
  end

  private

  def login_info_mailer
    UserMailer
  end
end
