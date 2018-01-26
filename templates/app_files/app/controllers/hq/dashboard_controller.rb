# frozen_string_literal: true

class Hq::DashboardController < Hq::ApplicationController
  add_breadcrumb I18n.t('view.dock.dashboard'), :hq_dashboard_index_path

  def index; end
end
