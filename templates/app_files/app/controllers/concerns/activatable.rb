# frozen_string_literal: true

module Activatable
  extend ActiveSupport::Concern

  private

  def activation_toggle(resource)
    if resource.update(is_active: !resource.is_active)
      i18n_key = "flash.actions.toggle_is_active.#{resource.is_active ? 'active' : 'passive'}"
      flash[:info] = I18n.t(i18n_key, resource_name: resource.class.model_name.human)
    else
      flash[:danger] = I18n.t('flash.messages.error_occurred')
    end
  end
end
