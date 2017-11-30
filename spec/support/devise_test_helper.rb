# frozen_string_literal: true

module DeviseTestHelper
  def devise_test
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'devise'/)

    devise_initializers_test
    devise_route_file_test
    devise_model_file_test
    file_control_test
  end

  private

  def devise_initializers_test
    initializers_devise = content('config/initializers/devise.rb')
    expect(initializers_devise).to match('mailer')
    expect(initializers_devise).to match('mailer_sender')

    filter_parameter_logging = content('config/initializers/filter_parameter_logging.rb')
    expect(filter_parameter_logging).to match(':password')
    expect(filter_parameter_logging).to match(':password_confirmation')
  end

  def devise_route_file_test
    devise_route = content('config/routes.rb')
    expect(devise_route).to match('devise_for :users')
  end

  def devise_model_file_test # rubocop:disable Metrics/AbcSize
    devise_model_file = content('app/models/user.rb')
    expect(devise_model_file).to match(':database_authenticatable')
    expect(devise_model_file).to match(':registerable')
    expect(devise_model_file).to match(':recoverable')
    expect(devise_model_file).to match(':rememberable')
    expect(devise_model_file).to match(':trackable')
    expect(devise_model_file).to match(':validatable')
  end

  def file_control_test
    expect(File).not_to exist(file_project_path('config/locales/devise.en.yml'))
  end
end
