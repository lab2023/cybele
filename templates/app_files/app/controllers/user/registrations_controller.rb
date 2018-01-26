# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, except: %i[new create]
  before_action :redirect_user, only: %i[destroy]
  add_breadcrumb I18n.t('activerecord.models.user'), :user_root_path

  def edit; end

  private

  def redirect_user
    redirect_to user_root_path
  end

  def after_update_path_for(_resource)
    user_root_path
  end
end
