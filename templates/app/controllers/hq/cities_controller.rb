class Hq::CitiesController < Hq::ApplicationController

  before_action :set_city, only: [:show, :edit, :update, :destroy]
  add_breadcrumb I18n.t('activerecord.models.cities'), :hq_cities_path

  def index
    @search = City.includes(:country).order(id: :desc).search(params[:q])
    @cities = @search.result(distinct: true).paginate(page: params[:page])
    respond_with(@cities)
  end

  def show
    add_breadcrumb @city.name, hq_city_path(@city)
    respond_with(@city)
  end

  def new
    add_breadcrumb t('tooltips.new'), new_hq_city_path
    @city = City.new
    respond_with(@city)
  end

  def edit
    add_breadcrumb @city.name, hq_city_path(@city)
    add_breadcrumb t('tooltips.edit'), edit_hq_city_path
  end

  def create
    @city = City.new(city_params)
    @city.save
    respond_with(:hq, @city)
  end

  def update
    @city.update(city_params)
    respond_with(:hq, @city)
  end

  def destroy
    @city.destroy
    respond_with(:hq, @city, location: request.referer)
  end

  private

  def city_params
    params.require(:city).permit(:name, :country_id)
  end

  def set_city
    @city = City.find(params[:id])
  end

end
