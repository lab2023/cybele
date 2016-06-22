class Hq::AdminsController < Hq::ApplicationController

  before_action :set_admin, only: [:show, :edit, :update, :destroy, :toggle_is_active]
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
    add_breadcrumb t('tooltips.new'), new_hq_admin_path
    @admin = Admin.new
    respond_with(@admin)
  end

  def edit
    add_breadcrumb @admin.name, hq_admin_path(@admin)
    add_breadcrumb t('tooltips.edit'), edit_hq_admin_path
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
    if @admin.update( is_active: !@admin.is_active )
      @admin.is_active ?
          flash[:info] = t('flash.actions.toggle_is_active.active', resource_name: Admin.model_name.human) :
          flash[:info] = t('flash.actions.toggle_is_active.passive', resource_name: Admin.model_name.human)
    else
      flash[:danger] = t('flash.messages.error_occurred')
    end
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
