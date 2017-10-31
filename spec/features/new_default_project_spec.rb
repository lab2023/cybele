# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project with default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele
    setup_app_dependencies
  end

  it 'uses default Gemfile' do
    gemfile_file = content('Gemfile')
    readme_file = content('README.md')
    expect(gemfile_file).to match(/^gem 'rails', '#{Cybele::RAILS_VERSION}'/)
    expect(readme_file).to match(/^# #{app_name.capitalize}/)
  end

  it 'uses postgresql database template' do
    database_file = content('config/database.yml')
    expect(database_file).to match(/^connection: &connection/)
    expect(database_file).to match(/^  database: #{app_name}_staging/)
  end

  it 'uses sidekiq' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'sidekiq'/)
    expect(gemfile_file).to match(/^gem 'sidekiq-cron'/)
    expect(gemfile_file).to match(/^gem 'cocaine'/)

    sidekiq_file = content('config/sidekiq.yml')
    expect(sidekiq_file).to match(/^:concurrency: 25/)

    sidekiq_schedule_file = content('config/sidekiq_schedule.yml')
    expect(sidekiq_schedule_file).to match(/-> Daily at midnight/)

    initializers_file = content('config/initializers/sidekiq.rb')
    expect(initializers_file).to match("^require 'sidekiq'")
    expect(initializers_file).to match("^require 'sidekiq/web'")

    routes_file = content('config/routes.rb')
    expect(routes_file).to match("^require 'sidekiq/web'")
    expect(routes_file).to match("^require 'sidekiq/cron/web'")
    expect(routes_file).to match(/# ========== Sidekiq ==========/)

    rake_file = content('lib/tasks/sidekiq.rake')
    expect(rake_file).to match(/^namespace :sidekiq/)
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

  it 'uses cybele_version' do
    expect(File).to exist(file_project_path('VERSION.txt'))
    expect(File).to exist(file_project_path('public/VERSION.txt'))
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

  it 'uses show_for' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'show_for'/)

    config_show_for_file = content('config/initializers/show_for.rb')
    expect(config_show_for_file).to match(/^ShowFor.setup/)

    show_for_en_yml_file = content('config/locales/show_for.en.yml')
    expect(show_for_en_yml_file).to match('show_for')

    show_for_tr_yml_file = content('config/locales/show_for.tr.yml')
    expect(show_for_tr_yml_file).to match('show_for')
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

  it 'uses recipient_interceptor' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'recipient_interceptor'/)

    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match('RecipientInterceptor.new')
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

  it 'uses simple_form' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'simple_form'/)

    config_simple_form_file = content('config/initializers/simple_form.rb')
    expect(config_simple_form_file).to match(/^SimpleForm.setup/)

    simple_form_bootstrap_file = content('config/initializers/simple_form_bootstrap.rb')
    expect(simple_form_bootstrap_file).to match(/^SimpleForm.setup/)

    simple_form_en_yml_file = content('config/locales/simple_form.en.yml')
    expect(simple_form_en_yml_file).to match('simple_form')

    simple_form_tr_yml_file = content('config/locales/simple_form.tr.yml')
    expect(simple_form_tr_yml_file).to match('simple_form')
  end

  it 'make control secret_key_base for staging' do
    secret_file = content('config/secrets.yml')
    expect(secret_file).to match('staging')
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

  it 'uses haml' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'haml'/)
    expect(gemfile_file).to match(/^gem 'haml-rails'/)

    expect(File).not_to exist(file_project_path('app/views/layouts/application.html.erb'))
    expect(File).to exist(file_project_path('app/views/layouts/application.html.haml'))
  end
end
