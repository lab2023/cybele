# frozen_string_literal: true

class User::ApplicationController < ApplicationController
  layout 'application'
  before_filter :set_audit_user, :set_user_time_zone
  before_action :authenticate_user!

  protected

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user.time_zone.present?
  end

  private

  def set_audit_user
    # Set audit current user
    Audited.current_user_method = :current_user
  end
end
