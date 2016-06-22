class Hq::CountriesController < Hq::ApplicationController

  before_action :set_country, only: [:show, :edit, :update, :destroy]
  add_breadcrumb I18n.t('activerecord.models.countries'), :hq_countries_path

  def index
    @search = Country.order(id: :desc).search(params[:q])
    @countries = @search.result(distinct: true).paginate(page: params[:page])
    respond_with(@countries)
  end

  def show
    add_breadcrumb @country.name, hq_country_path(@country)
    respond_with(@country)
  end

  def new
    add_breadcrumb t('tooltips.new'), new_hq_country_path
    @country = Country.new
    respond_with(@country)
  end

  def edit
    add_breadcrumb @country.name, hq_country_path(@country)
    add_breadcrumb t('tooltips.edit'), edit_hq_country_path
  end

  def create
    @country = Country.new(country_params)
    @country.save
    respond_with(:hq, @country)
  end

  def update
    @country.update(country_params)
    respond_with(:hq, @country)
  end

  def destroy
    @country.destroy
    respond_with(:hq, @country, location: request.referer)
  end

  private

  def country_params
    params.require(:country).permit(:name)
  end

  def set_country
    @country = Country.find(params[:id])
  end

end
