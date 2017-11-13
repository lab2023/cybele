# frozen_string_literal: true

module GemTestHelpers
  def devise_test_helper
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'devise'/)

    initializers_devise = content('config/initializers/devise.rb')
    expect(initializers_devise).to match('mailer')
    expect(initializers_devise).to match('mailer_sender')

    filter_parameter_logging = content('config/initializers/filter_parameter_logging.rb')
    expect(filter_parameter_logging).to match(':password')
    expect(filter_parameter_logging).to match(':password_confirmation')

    devise_model_file = content('app/models/user.rb')
    expect(devise_model_file).to match(':database_authenticatable')
    expect(devise_model_file).to match(':registerable')
    expect(devise_model_file).to match(':recoverable')
    expect(devise_model_file).to match(':rememberable')
    expect(devise_model_file).to match(':trackable')
    expect(devise_model_file).to match(':validatable')

    devise_route = content('config/routes.rb')
    expect(devise_route).to match('devise_for :users')

    expect(File).to exist(file_project_path('app/views/devise/confirmations'))
    expect(File).to exist(file_project_path('app/views/devise/mailer'))
    expect(File).to exist(file_project_path('app/views/devise/passwords'))
    expect(File).to exist(file_project_path('app/views/devise/registrations'))
    expect(File).to exist(file_project_path('app/views/devise/sessions'))
    expect(File).to exist(file_project_path('app/views/devise/shared'))
    expect(File).to exist(file_project_path('app/views/devise/unlocks'))

    expect(File).not_to exist(file_project_path('config/locales/devise.en.yml'))
  end

  def responder_test_helper
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'responders'/)

    lib_file = content('lib/application_responder.rb')
    expect(lib_file).to match(/^class ApplicationResponder/)

    controller_file = content('app/controllers/application_controller.rb')
    expect(controller_file).to match("^require 'application_responder'")
    expect(controller_file).to match('self.responder = ApplicationResponder')
    expect(controller_file).to match('respond_to :html, :js, :json')

    expect(File).to exist(file_project_path('config/locales/responders.en.yml'))
    locale_file = content('config/locales/responders.tr.yml')
    expect(locale_file).not_to match('# alert:')
    expect(locale_file).to match('create:')
    expect(locale_file).to match('update:')
    expect(locale_file).to match('destroy:')
  end

  def locale_language_test_helper
    expect(File).to exist(file_project_path('config/locales/en.yml'))
    locale_file = content('config/locales/tr.yml')
    expect(locale_file).to match('phone:')
    expect(locale_file).to match('date:')
    expect(locale_file).to match('time:')
    expect(locale_file).to match('number:')

    locale_file = content('config/locales/email.en.yml')
    expect(locale_file).to match('email:')

    locale_file = content('config/locales/email.tr.yml')
    expect(locale_file).to match('email:')

    locale_file = content('config/locales/models.en.yml')
    expect(locale_file).to match('activerecord:')

    locale_file = content('config/locales/models.tr.yml')
    expect(locale_file).to match('activerecord:')

    locale_file = content('config/locales/view.en.yml')
    expect(locale_file).to match('view:')

    locale_file = content('config/locales/view.tr.yml')
    expect(locale_file).to match('view:')
  end

  def paperclip_test_helper
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem "paperclip"/)
    expect(gemfile_file).to match(/^gem 'aws-sdk'/)

    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('S3_BUCKET_NAME=')
    expect(env_sample_file).to match('AWS_RAW_URL=')
    expect(env_sample_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_sample_file).to match('AWS_SECRET_ACCESS_KEY=')

    env_local_file = content('.env.local')
    expect(env_local_file).to match('S3_BUCKET_NAME=dummy_app-development')
    expect(env_local_file).to match('AWS_RAW_URL=dummy_app-development.s3.amazonaws.com')
    expect(env_local_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_local_file).to match('AWS_SECRET_ACCESS_KEY=')

    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('S3_BUCKET_NAME=dummy_app-staging')
    expect(env_staging_file).to match('AWS_RAW_URL=dummy_app-staging.s3.amazonaws.com')
    expect(env_staging_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_staging_file).to match('AWS_SECRET_ACCESS_KEY=')

    env_production_file = content('.env.production')
    expect(env_production_file).to match('S3_BUCKET_NAME=dummy_app')
    expect(env_production_file).to match('AWS_RAW_URL=dummy_app.s3.amazonaws.com')
    expect(env_production_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_production_file).to match('AWS_SECRET_ACCESS_KEY=')
  end

  def dotenv_test_helper
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'dotenv-rails'/)

    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('ROOT_PATH=http://localhost:3000')

    env_local_file = content('.env.local')
    expect(env_local_file).to match('ROOT_PATH=http://localhost:3000')

    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('ROOT_PATH=https://staging-dummy_app.herokuapp.com')

    env_production_file = content('.env.production')
    expect(env_production_file).to match('ROOT_PATH=https://dummy_app.herokuapp.com')
  end

  def config_test_helper
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'config'/)

    config_development_file = content('config/environments/development.rb')
    expect(config_development_file).to match(/^Rails.application.configure/)

    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match(/^Rails.application.configure/)

    config_production_file = content('config/environments/production.rb')
    expect(config_production_file).to match(/^Rails.application.configure/)

    config_test_file = content('config/environments/test.rb')
    expect(config_test_file).to match(/^Rails.application.configure/)
  end

  def error_pages_helper
    application_controller_file = content('app/controllers/application_controller.rb')
    expect(application_controller_file).to match('rescue_from Exception')
    expect(application_controller_file).to match('rescue_from ActiveRecord::RecordNotFound')
    expect(application_controller_file).to match('rescue_from ActionController::RoutingError')
    expect(application_controller_file).to match('server_error')
    expect(application_controller_file).to match('page_not_found')

    route_file = content('config/routes.rb')
    expect(route_file).to match('unmatched_route')
  end

  def gitignore_helper
    application_controller_file = content('.gitignore')
    expect(application_controller_file).to match('.DS_Store')
    expect(application_controller_file).to match('.secret')
    expect(application_controller_file).to match('.env')
  end
end
