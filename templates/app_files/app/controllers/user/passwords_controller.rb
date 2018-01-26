# frozen_string_literal: true

class User::PasswordsController < Devise::PasswordsController
  private

  def after_resetting_password_path_for(_resource)
    user_root_path
  end
end
