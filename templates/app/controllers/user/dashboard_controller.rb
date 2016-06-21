class User::DashboardController < User::UserApplicationController

  add_breadcrumb I18n.t('dock.dashboard'), :user_dashboard_index_path

  def index
  end

end