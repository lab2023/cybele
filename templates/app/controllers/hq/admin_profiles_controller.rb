# encoding: UTF-8
class Hq::AdminProfilesController < Hq::ApplicationController
  
  before_action :check_profile, only: [:new, :create]
  before_action :profile_controller, except: [:new, :create] 
  before_action :set_admin_profile, only: [:show, :edit, :update]
  add_breadcrumb I18n.t('activerecord.models.admin_profiles'), :hq_admin_profile_path

  def show
    add_breadcrumb @admin_profile.first_name, hq_admin_profile_path
    respond_with([:hq, @admin_profile])
  end

  def new
    add_breadcrumb t('tooltips.new'), new_hq_admin_profile_path
    @admin_profile = current_admin.build_admin_profile
    respond_with([:hq, @admin_profile])
  end

  def edit
    add_breadcrumb t('tooltips.edit'), edit_hq_admin_profile_path
  end

  def create
    @admin_profile = current_admin.build_admin_profile(admin_profile_params)
    @admin_profile.save
    respond_with([:hq, @admin_profile], location: hq_admin_profile_path)
  end

  def update
    @admin_profile.update(admin_profile_params)
    respond_with([:hq, @admin_profile], location: hq_admin_profile_path)
  end

  private

  def profile_controller
    if current_admin.admin_profile.nil?
      redirect_to new_hq_admin_profile_path
    end
  end

  def check_profile
    if current_admin.admin_profile.present?
      redirect_to user_profile_path
    end
  end

  def set_admin_profile
    @admin_profile = current_admin.admin_profile
  end

  def admin_profile_params
    params.require(:admin_profile).permit(:first_name, :gsm, :last_name)
  end
end
