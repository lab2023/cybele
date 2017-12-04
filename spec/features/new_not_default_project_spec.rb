# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele('--database=sqlite3 --skip-create-database --skip-sidekiq --skip-simple-form --skip-show-for'\
               ' --skip-haml --skip-docker --skip-view-files')
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
    expect(gemfile_file).to match(/^gem 'will_paginate-bootstrap'/)
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

  it 'do not use asset files' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'bootstrap'/)

    expect(File).to exist(file_project_path('app/assets/stylesheets/application.css'))
    expect(File).not_to exist(file_project_path('app/assets/stylesheets/application.css.sass'))
    expect(File).not_to exist(file_project_path('app/assets/stylesheets/hq/application.css.sass'))

    expect(File).to exist(file_project_path('app/assets/javascripts/application.js'))
    expect(File).not_to exist(file_project_path('app/assets/javascripts/hq/application.js'))
  end

  it 'do not use controller files' do
    expect(File).to exist(file_project_path('app/controllers/application_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/admins_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/application_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/audits_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/dashboard_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/passwords_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/registrations_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/sessions_controller.rb'))
    expect(File).not_to exist(file_project_path('app/controllers/hq/users_controller.rb'))
  end

  it 'do not use view files with option' do
    # HQ files
    expect(File).not_to exist(file_project_path('app/views/hq/admins/index.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/audits/index.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/dashboard/index.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/passwords/new.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/registrations/edit.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/sessions/new.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/hq/users/index.html.haml'))

    # Layouts
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_breadcrumb.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_dock.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_footer.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_navbar.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_toolbar.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/hq/partials/_trackers.html.haml'))

    expect(File).not_to exist(file_project_path('app/views/layouts/partials/_messages.html.haml'))
    expect(File).not_to exist(file_project_path('app/views/layouts/partials/_warnings.html.haml'))

    # Devise view files
    expect(File).not_to exist(file_project_path('app/views/devise/confirmations'))
    expect(File).not_to exist(file_project_path('app/views/devise/mailer'))
    expect(File).not_to exist(file_project_path('app/views/devise/passwords'))
    expect(File).not_to exist(file_project_path('app/views/devise/registrations'))
    expect(File).not_to exist(file_project_path('app/views/devise/sessions'))
    expect(File).not_to exist(file_project_path('app/views/devise/shared'))
    expect(File).not_to exist(file_project_path('app/views/devise/unlocks'))
  end

  it 'uses default view files' do
    # Mailer files
    hq_admins_view = content('app/views/admin_mailer/login_info.html.haml')
    expect(hq_admins_view).to match('@admin')
  end

  it 'not configure routes file' do
    route_file = content('config/routes.rb')
    expect(route_file).not_to match('concern :activeable')
  end

  it 'uses model files' do
    admin_model = content('app/models/admin.rb')
    expect(admin_model).to match('AdminMailer.login_info')

    audit_model = content('app/models/audit.rb')
    expect(audit_model).to match('class Audit')
  end

  it 'uses mailer files' do
    admin_mailer = content('app/mailers/admin_mailer.rb')
    expect(admin_mailer).to match('class AdminMailer')

    application_mailer = content('app/mailers/application_mailer.rb')
    expect(application_mailer).to match('Settings.email.noreply')
  end

  it 'uses ssl_setting' do
    force_ssl
  end

  it "don't use docker development environment" do
    expect(File).not_to exist(file_project_path('docker-compose.yml'))
    expect(File).not_to exist(file_project_path('Dockerfile'))
    expect(File).not_to exist(file_project_path('bin/start-app.sh'))
    expect(File).not_to exist(file_project_path('bin/start-sidekiq.sh'))

    env_sample_file = content('env.sample')
    expect(env_sample_file).not_to match('REDISTOGO_URL=redis://redis:6379/0')

    env_local_file = content('.env.local')
    expect(env_local_file).not_to match('REDISTOGO_URL=redis://redis:6379/0')

    env_staging_file = content('.env.staging')
    expect(env_staging_file).not_to match('REDISTOGO_URL=')

    env_production_file = content('.env.production')
    expect(env_production_file).not_to match('REDISTOGO_URL=')
  end

  it 'uses pronto' do
    pronto_test
  end
end
