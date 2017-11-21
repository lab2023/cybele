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
    responder_test
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
    config_test
  end

  it 'uses locale_language' do
    locale_language_test
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
    paperclip_test
  end

  it 'control env.sample and .env files' do
    dotenv_test
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

  it 'do not use haml' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'haml'/)
    expect(gemfile_file).not_to match(/^gem 'haml-rails'/)

    expect(File).to exist(file_project_path('app/views/layouts/application.html.erb'))
    expect(File).not_to exist(file_project_path('app/views/layouts/application.html.haml'))
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
end
