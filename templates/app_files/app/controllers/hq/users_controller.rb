# frozen_string_literal: true

class Hq::UsersController < Hq::ApplicationController
  include Activatable

  before_action :set_user, only: %i[show edit update destroy toggle_is_active]
  add_breadcrumb I18n.t('activerecord.models.users'), :hq_users_path

  def index
    @search = User.order(id: :desc).search(params[:q])
    @users = @search.result(distinct: true).paginate(page: params[:page])
    respond_with(@users)
  end

  def show
    add_breadcrumb @user.name, hq_user_path(@user)
    respond_with(@user)
  end

  def new
    add_breadcrumb t('view.tooltips.new'), new_hq_user_path
    @user = User.new
    respond_with(@user)
  end

  def edit
    add_breadcrumb @user.name, hq_user_path(@user)
    add_breadcrumb t('view.tooltips.edit'), edit_hq_user_path
  end

  def create
    @user = User.new(user_params)
    @user.save
    respond_with(:hq, @user)
  end

  def update
    @user.update(user_params)
    respond_with(:hq, @user)
  end

  def destroy
    @user.destroy
    respond_with(:hq, @user, location: request.referer)
  end

  def toggle_is_active
    activation_toggle(@user)
    respond_with(:hq, @user, location: request.referer)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :surname, :time_zone)
  end
end
