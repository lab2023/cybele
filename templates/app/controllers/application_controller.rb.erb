require 'application_responder'

class ApplicationController < ActionController::Base
  include BasicAuthentication

  rescue_from Exception, with: :server_error if Rails.env.production? or Rails.env.staging?
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found if Rails.env.production? or Rails.env.staging?
  rescue_from ActionController::RoutingError, with: :page_not_found if Rails.env.production? or Rails.env.staging?

  self.responder = ApplicationResponder
  respond_to :html, :json

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_audit_user
  protect_from_forgery with: :exception

  def server_error(exception)
    Rollbar.error "ApplicationController#server_error --exception: #{exception}"
    render template: 'errors/internal_server_error', status: 500
  end

  def page_not_found
    render template: 'errors/not_found', status: 404
  end

  protected

  def set_user_time_zone
    Time.zone = current_user.time_zone if student_signed_in? && current_student.time_zone.present?
  end

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super # Use the default one
    end
  end

  private

  def set_audit_user
    # Set audit current user
    Audited.current_user_method = :current_user
  end

end