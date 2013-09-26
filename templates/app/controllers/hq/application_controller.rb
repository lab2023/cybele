require 'application_responder'

class Hq::ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  self.responder = ApplicationResponder
  respond_to :html, :json
end