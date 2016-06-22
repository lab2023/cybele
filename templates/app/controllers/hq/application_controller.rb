require 'application_responder'

class Hq::ApplicationController < ActionController::Base

  before_filter :set_audit_user
  before_action :authenticate_admin!

  self.responder = ApplicationResponder
  respond_to :html, :json

  private

  def set_audit_user
    # Set audit current user
    Audited.current_user_method = :current_admin
  end

end