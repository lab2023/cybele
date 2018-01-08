# frozen_string_literal: true

module PasswordCreatable
  extend ActiveSupport::Concern

  included do
    # Virtual attributes
    attr_reader :is_generated_password
    # Callbacks
    after_commit :send_login_info, on: :create
    before_validation :create_password, on: :create
    after_initialize do |obj|
      obj.is_generated_password = false
    end
  end

  protected

  # Virtual attributes
  attr_writer :is_generated_password

  private

  def create_password
    return if password.present?
    password = Devise.friendly_token.first(8)
    self.password = password
    self.password_confirmation = password
    self.is_generated_password = true
  end

  def send_login_info
    login_info_mailer.login_info(id, password).deliver_later! if is_generated_password
  end

  def login_info_mailer
    raise NotImplementedError
  end
end
