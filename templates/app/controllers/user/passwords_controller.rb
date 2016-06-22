class User::PasswordsController < Devise::PasswordsController
  # layout 'user/login'

  private

  def after_resetting_password_path_for(resource)
    user_root_path
  end

end
