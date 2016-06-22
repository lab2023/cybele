class Hq::PasswordsController < Devise::PasswordsController
  layout 'hq/login'

  private

  def after_resetting_password_path_for(resource)
    hq_root_path
  end

end
