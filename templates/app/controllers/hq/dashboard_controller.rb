class Hq::DashboardController < Hq::ApplicationController

  add_breadcrumb I18n.t('dock.dashboard'), :hq_dashboard_index_path

  def index
  end

end