class User::ProfileController < User::UserApplicationController

  before_action :set_profile, only: [:show, :edit, :update]
  add_breadcrumb I18n.t('dock.profile'), :user_profile_path

  def show
    add_breadcrumb @profile.full_name, user_profile_path
    respond_with([:user, @profile])
  end

  def edit
    add_breadcrumb t('tooltips.edit'), edit_user_profile_path
  end

  def update
    @profile.update(profile_params)
    respond_with([:user, @profile], location: user_profile_path)
  end

  private

  def set_profile
    @profile = current_user
  end

  def profile_params
    params.require(:user)
      .permit(
        :name,
        :surname,
        :time_zone
    )
  end
end
