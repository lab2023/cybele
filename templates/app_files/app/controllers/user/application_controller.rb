# frozen_string_literal: true

class User::ApplicationController < ApplicationController
  layout 'application'
  before_action :authenticate_user!
  before_action :set_user_time_zone
  self.responder = ApplicationResponder

  protected

  def set_user_time_zone
    time_zone = current_user.time_zone
    Time.zone = time_zone if time_zone.present?

    # Set audit current user
    Audited.current_user_method = :current_user
  end
end
