class Hq::ProfileController < Hq::ApplicationController
  before_action :set_admin, only: [:edit, :update]

  def edit
  end

  def update
    if @admin.valid_password? params[:admin][:current_password] && @admin.update(admin_params)
      sign_in @admin
      redirect_to hq_dashboard_index_path
    else
      render 'edit'
    end
  end

  private

  def set_admin
    @admin = current_admin
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end