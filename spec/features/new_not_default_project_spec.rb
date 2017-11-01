# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele('--database=sqlite3 --skip-create-database --skip-sidekiq --skip-simple-form --skip-show-for'\
               ' --skip-haml')
    setup_app_dependencies
  end

  it 'uses sqlite3 instead of default pg in Gemfile' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'pg'/)
    expect(gemfile_file).to match(/^gem 'sqlite3'/)
  end

  it 'uses sqlite3 database template' do
    database_file = content('config/database.yml')
    expect(database_file).to match(/^default: &default/)
    expect(database_file).to match(/adapter: sqlite3/)
  end

  it 'do not use sidekiq' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'sidekiq'/)
    expect(gemfile_file).not_to match(/^gem 'sidekiq-cron'/)
    expect(gemfile_file).not_to match(/^gem 'cocaine'/)
    expect(gemfile_file).not_to match(/^gem 'devise-async'/)

    expect(File).not_to exist(file_project_path('config/sidekiq.yml'))

    expect(File).not_to exist(file_project_path('config/sidekiq_schedule.yml'))
    expect(File).not_to exist(file_project_path('config/initializers/sidekiq.rb'))
    expect(File).not_to exist(file_project_path('lib/tasks/sidekiq.rake'))

    routes_file = content('config/routes.rb')
    expect(routes_file).not_to match("^require 'sidekiq/web'")
    expect(routes_file).not_to match("^require 'sidekiq/cron/web'")
  end

  it 'uses responders' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'responders'/)

    lib_file = content('lib/application_responder.rb')
    expect(lib_file).to match(/^class ApplicationResponder/)

    controller_file = content('app/controllers/application_controller.rb')
    expect(controller_file).to match("^require 'application_responder'")
    expect(controller_file).to match('self.responder = ApplicationResponder')
    expect(controller_file).to match('respond_to :html, :js, :json')

    expect(File).to exist(file_project_path('config/locales/responders.en.yml'))
    expect(File).to exist(file_project_path('config/locales/responders.tr.yml'))
    locale_file = content('config/locales/responders.tr.yml')
    expect(locale_file).not_to match('# alert:')
    expect(locale_file).to match('create:')
    expect(locale_file).to match('update:')
    expect(locale_file).to match('destroy:')
  end

  it 'uses rollbar' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'rollbar'/)

    config_file = content('config/initializers/rollbar.rb')
    expect(config_file).to match(/^Rollbar.configure/)
  end

  it 'uses ransack' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'ransack'/)
  end

  it 'uses will_paginate' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'will_paginate'/)
  end

  it 'uses to_xls' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'to_xls'/)
  end

  it 'uses roo' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'roo'/)
  end

  it 'uses roo-xls' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'roo-xls'/)
  end

  it 'uses write_xlsx' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'write_xlsx'/)
  end

  it 'uses colorize' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'colorize'")
  end

  it 'uses better_errors' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'better_errors'")
  end

  it 'uses rails-i18n' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'rails-i18n'/)
  end

  it 'do not use show_for' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'show_for'/)

    expect(File).not_to exist(file_project_path('config/initializers/show_for.rb'))
    expect(File).not_to exist(file_project_path('config/locales/show_for.en.yml'))
    expect(File).not_to exist(file_project_path('config/locales/show_for.tr.yml'))
  end

  it 'uses config and staging file' do
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

  it 'uses locale_language' do
    expect(File).to exist(file_project_path('config/locales/en.yml'))
    expect(File).to exist(file_project_path('config/locales/tr.yml'))
    locale_file = content('config/locales/tr.yml')
    expect(locale_file).to match('phone:')
    expect(locale_file).to match('date:')
    expect(locale_file).to match('time:')
    expect(locale_file).to match('number:')

    expect(File).to exist(file_project_path('config/locales/email.en.yml'))
    locale_file = content('config/locales/email.en.yml')
    expect(locale_file).to match('email:')

    expect(File).to exist(file_project_path('config/locales/email.tr.yml'))
    locale_file = content('config/locales/email.tr.yml')
    expect(locale_file).to match('email:')

    expect(File).to exist(file_project_path('config/locales/models.en.yml'))
    locale_file = content('config/locales/models.en.yml')
    expect(locale_file).to match('activerecord:')

    expect(File).to exist(file_project_path('config/locales/models.tr.yml'))
    locale_file = content('config/locales/models.tr.yml')
    expect(locale_file).to match('activerecord:')

    expect(File).to exist(file_project_path('config/locales/view.en.yml'))
    locale_file = content('config/locales/view.en.yml')
    expect(locale_file).to match('view:')

    expect(File).to exist(file_project_path('config/locales/view.tr.yml'))
    locale_file = content('config/locales/view.tr.yml')
    expect(locale_file).to match('view:')
  end

  it 'uses recipient_interceptor' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'recipient_interceptor'/)

    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match('RecipientInterceptor.new')
  end

  it 'uses cybele_version' do
    expect(File).to exist(file_project_path('VERSION.txt'))
    expect(File).to exist(file_project_path('public/VERSION.txt'))
  end

  it 'uses bullet' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'bullet'")

    locale_file = content('config/environments/development.rb')
    expect(locale_file).to match('Bullet')
  end

  it 'do not use simple_form' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'simple_form'/)

    expect(File).not_to exist(file_project_path('config/initializers/simple_form.rb'))
    expect(File).not_to exist(file_project_path('config/initializers/simple_form_bootstrap.rb'))
    expect(File).not_to exist(file_project_path('config/locales/simple_form.en.yml'))
    expect(File).not_to exist(file_project_path('config/locales/simple_form.tr.yml'))
  end

  it 'make control secret_key_base for staging' do
    secret_file = content('config/secrets.yml')
    expect(secret_file).to match('staging')
  end

  it 'uses paperclip' do
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

  it 'control env.sample and .env files' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'dotenv-rails'/)

    expect(File).to exist(file_project_path('env.sample'))
    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('ROOT_PATH=http://localhost:3000')

    expect(File).to exist(file_project_path('.env.local'))
    env_local_file = content('.env.local')
    expect(env_local_file).to match('ROOT_PATH=http://localhost:3000')

    expect(File).to exist(file_project_path('.env.staging'))
    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('ROOT_PATH=https://staging-dummy_app.herokuapp.com')

    expect(File).to exist(file_project_path('.env.production'))
    env_production_file = content('.env.production')
    expect(env_production_file).to match('ROOT_PATH=https://dummy_app.herokuapp.com')
  end

  it 'do not use haml' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'haml'/)
    expect(gemfile_file).not_to match(/^gem 'haml-rails'/)

    expect(File).to exist(file_project_path('app/views/layouts/application.html.erb'))
    expect(File).not_to exist(file_project_path('app/views/layouts/application.html.haml'))
  end

  it 'uses devise' do
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

    devise_user_sanitizer = content('lib/user_sanitizer.rb')
    expect(devise_user_sanitizer).to match(':name')
    expect(devise_user_sanitizer).to match(':surname')
    expect(devise_user_sanitizer).to match(':email')
    expect(devise_user_sanitizer).to match(':password')
    expect(devise_user_sanitizer).to match(':password_confirmation')
    expect(devise_user_sanitizer).to match(':time_zone')

    devise_sanitizers = content('config/initializers/sanitizers.rb')
    expect(devise_sanitizers).to match('require')

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
end
