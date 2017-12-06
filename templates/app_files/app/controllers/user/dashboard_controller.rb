# frozen_string_literal: true

class User::DashboardController < User::ApplicationController
  add_breadcrumb I18n.t('view.dock.dashboard'), :user_dashboard_index_path

  def index; end
end
