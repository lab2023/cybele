require 'application_responder'

class User::UserApplicationController < ActionController::Base
  # layout 'user/application'
  before_action :authenticate_user!
  self.responder = ApplicationResponder
  respond_to :html, :json
end