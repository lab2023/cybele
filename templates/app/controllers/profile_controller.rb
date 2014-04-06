class ProfileController < ApplicationController
  before_action :set_user, :authenticate_user!, only: [:edit, :update]

  def edit
  end

  def update
    if @user.valid_password? params[:user][:current_password] && @user.update(user_params)
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end