class User::RegistrationsController < Devise::RegistrationsController
  # layout 'user/application'
  before_action :authenticate_user!, except: [:new, :create]
  before_action :redirect_user, only: [:destroy]
  add_breadcrumb I18n.t('activerecord.models.user'), :user_root_path

  def edit
  end

  private

  def redirect_user
    redirect_to user_root_path
  end

  def after_update_path_for(resource)
    user_root_path
  end

end