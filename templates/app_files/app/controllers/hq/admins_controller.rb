# frozen_string_literal: true

class Hq::AdminsController < Hq::ApplicationController
  include Activatable

  before_action :set_admin, only: %i[show edit update destroy toggle_is_active]
  add_breadcrumb I18n.t('activerecord.models.admins'), :hq_admins_path

  def index
    @search = Admin.order(id: :desc).search(params[:q])
    @admins = @search.result(distinct: true).paginate(page: params[:page])
    respond_with(@admins)
  end

  def show
    add_breadcrumb @admin.name, hq_admin_path(@admin)
    respond_with(@admin)
  end

  def new
    add_breadcrumb t('view.tooltips.new'), new_hq_admin_path
    @admin = Admin.new
    respond_with(@admin)
  end

  def edit
    add_breadcrumb @admin.name, hq_admin_path(@admin)
    add_breadcrumb t('view.tooltips.edit'), edit_hq_admin_path
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.save
    respond_with(:hq, @admin)
  end

  def update
    @admin.update(admin_params)
    respond_with(:hq, @admin)
  end

  def destroy
    @admin.destroy
    respond_with(:hq, @admin, location: request.referer)
  end

  def toggle_is_active
    activation_toggle(@admin)
    respond_with(:hq, @admin, location: request.referer)
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :name, :surname)
  end
end
