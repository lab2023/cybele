# frozen_string_literal: true

class Hq::RegistrationsController < Devise::RegistrationsController
  layout 'hq/application'
  before_action :authenticate_admin!
  before_action :redirect_admin, only: %i[new create destroy]
  add_breadcrumb I18n.t('view.dock.dashboard'), :hq_dashboard_index_path

  def edit
    add_breadcrumb I18n.t('view.title.edit', resource_name: Admin.model_name.human)
  end

  private

  def redirect_admin
    redirect_to hq_root_path
  end

  def after_update_path_for(_resource)
    hq_root_path
  end
end
