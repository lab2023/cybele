# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project with default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele('--skip-create-database')
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
    expect(gemfile_file).to match(/^gem 'devise-async'/)

    sidekiq_file = content('config/sidekiq.yml')
    expect(sidekiq_file).to match('[high_priority, 2]')

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
    responder_test
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
    config_test
  end

  it 'uses recipient_interceptor' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'recipient_interceptor'/)

    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match('RecipientInterceptor.new')
  end

  it 'uses locale_language' do
    locale_language_test
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
    dotenv_test
  end

  it 'uses paperclip' do
    paperclip_test
  end

  it 'uses mailer' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'letter_opener'")

    expect(File).to exist(file_project_path('config/settings/production.yml'))
    expect(File).to exist(file_project_path('config/settings/staging.yml'))

    mail_test_helper('config/settings.yml')
    mail_test_helper('config/environments/production.rb')
    mail_test_helper('config/environments/staging.rb')

    development_file = content('config/environments/development.rb')
    expect(development_file).to match('host:')
    expect(development_file).to match(':letter_opener')
  end

  it 'uses haml' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'haml'/)
    expect(gemfile_file).to match(/^gem 'haml-rails'/)

    expect(File).not_to exist(file_project_path('app/views/layouts/application.html.erb'))
    expect(File).to exist(file_project_path('app/views/layouts/application.html.haml'))
  end

  it 'uses bullet' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'bullet'")

    locale_file = content('config/environments/development.rb')
    expect(locale_file).to match('Bullet')
  end

  it 'uses devise' do
    devise_test
  end

  it 'uses error_pages' do
    error_pages_test
  end

  it 'uses gitignore' do
    git_ignore_test
  end

  it 'uses ssl_setting' do
    force_ssl
  end

  it 'uses docker development environment' do
    expect(File).to exist(file_project_path('docker-compose.yml'))
    expect(File).to exist(file_project_path('Dockerfile'))
    expect(File).to exist(file_project_path('bin/start-app.sh'))
    expect(File).to exist(file_project_path('bin/start-sidekiq.sh'))

    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('REDISTOGO_URL=redis://redis:6379/0')
    expect(env_sample_file).to match('RACK_ENV=development')
    expect(env_sample_file).to match('POSTGRESQL_HOST=postgres')
    expect(env_sample_file).to match('REDIS_HOST=redis')

    env_local_file = content('.env.local')
    expect(env_local_file).to match('REDISTOGO_URL=redis://redis:6379/0')
    expect(env_local_file).to match('RACK_ENV=development')
    expect(env_local_file).to match('POSTGRESQL_HOST=postgres')
    expect(env_local_file).to match('REDIS_HOST=redis')

    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('REDISTOGO_URL=')

    env_production_file = content('.env.production')
    expect(env_production_file).to match('REDISTOGO_URL=')
  end

  it 'uses pronto' do
    pronto_test
  end
end
