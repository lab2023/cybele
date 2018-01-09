# frozen_string_literal: true

class Hq::ApplicationController < ApplicationController
  before_action :set_audit_user
  layout 'hq/application'
  self.responder = ApplicationResponder

  private

  def set_audit_user
    Audited.current_user_method = :current_admin
  end
end
