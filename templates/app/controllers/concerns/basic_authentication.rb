module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_filter :authenticate
  end

  private

  def authenticate
    if Rails.env.staging? and ENV['BASIC_AUTH_IS_ACTIVE'] == 'yes'
      authenticate_or_request_with_http_basic do |username, password|
        username == Settings.basic_auth.username && password == Settings.basic_auth.password
      end
    end
  end

end