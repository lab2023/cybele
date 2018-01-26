# frozen_string_literal: true

module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private

  def authenticate
    return unless ENV['BASIC_AUTH_IS_ACTIVE'] == 'yes'
    authenticate_or_request_with_http_basic do |username, password|
      username == basic_auth.username && password == basic_auth.password
    end
  end

  def basic_auth
    Settings.basic_auth
  end
end
