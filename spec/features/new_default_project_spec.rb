# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project with default configuration' do
  before(:all) do
    remove_project_directory
    run_cybele('--skip-create-database')
    setup_app_dependencies
  end

  it 'uses default Gemfile' do
    gemfile_file = content('Gemfile')
    readme_file = content('README.md')
    expect(gemfile_file).to match(/^gem 'rails', '#{Cybele::RAILS_VERSION}'/)
    expect(readme_file).to match(/^# #{app_name.capitalize}/)
    expect(readme_file).to match(/^# Docker development/)
    expect(readme_file).to match(/^➜ ✗ redis-server/)
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

  it 'control .env files' do
    dotenv_test
  end

  it 'uses mailer' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'mailtrap'")

    expect(File).to exist(file_project_path('config/settings/production.yml'))
    expect(File).to exist(file_project_path('config/settings/staging.yml'))

    mail_test_helper('config/settings.yml')
    mail_test_helper('config/environments/production.rb')
    mail_test_helper('config/environments/staging.rb')
    mail_test_helper('config/environments/development.rb')
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

  it 'uses asset files' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'bootstrap'/)

    expect(File).not_to exist(file_project_path('app/assets/stylesheets/application.css'))

    application_stylesheets_file = content('app/assets/stylesheets/application.sass')
    expect(application_stylesheets_file).to match('@import "bootstrap"')

    hq_stylesheets_js_file = content('app/assets/stylesheets/hq/application.sass')
    expect(hq_stylesheets_js_file).to match('@import "bootstrap"')

    application_js_file = content('app/assets/javascripts/application.js')
    expect(application_js_file).to match('require bootstrap')

    hq_application_js_file = content('app/assets/javascripts/hq/application.js')
    expect(hq_application_js_file).to match('require bootstrap')
  end

  it 'uses controller files' do
    application_controller = content('app/controllers/application_controller.rb')
    expect(application_controller).to match('class ApplicationController')
    expect(application_controller).to match('configure_devise_permitted_parameters')

    # Hq files
    hq_admins_controller = content('app/controllers/hq/admins_controller.rb')
    expect(hq_admins_controller).to match('class Hq::AdminsController')

    hq_application_controller = content('app/controllers/hq/application_controller.rb')
    expect(hq_application_controller).to match('class Hq::ApplicationController')
    expect(hq_application_controller).to match('before_action :authenticate_admin!')

    hq_audits_controller = content('app/controllers/hq/audits_controller.rb')
    expect(hq_audits_controller).to match('class Hq::AuditsController')

    hq_dashboard_controller = content('app/controllers/hq/dashboard_controller.rb')
    expect(hq_dashboard_controller).to match('class Hq::DashboardController')

    hq_passwords_controller = content('app/controllers/hq/passwords_controller.rb')
    expect(hq_passwords_controller).to match('class Hq::PasswordsController')

    hq_registrations_controller = content('app/controllers/hq/registrations_controller.rb')
    expect(hq_registrations_controller).to match('class Hq::RegistrationsController')

    hq_sessions_controller = content('app/controllers/hq/sessions_controller.rb')
    expect(hq_sessions_controller).to match('class Hq::SessionsController')

    hq_users_controller = content('app/controllers/hq/users_controller.rb')
    expect(hq_users_controller).to match('class Hq::UsersController')

    # User files
    user_application_controller = content('app/controllers/user/application_controller.rb')
    expect(user_application_controller).to match('class User::ApplicationController')
    expect(user_application_controller).to match('before_action :authenticate_user!')

    user_dashboard_controller = content('app/controllers/user/dashboard_controller.rb')
    expect(user_dashboard_controller).to match('class User::DashboardController')

    user_passwords_controller = content('app/controllers/user/passwords_controller.rb')
    expect(user_passwords_controller).to match('class User::PasswordsController')

    user_profile_controller = content('app/controllers/user/profile_controller.rb')
    expect(user_profile_controller).to match('class User::ProfileController')

    user_registrations_controller = content('app/controllers/user/registrations_controller.rb')
    expect(user_registrations_controller).to match('class User::RegistrationsController')

    user_sessions_controller = content('app/controllers/user/sessions_controller.rb')
    expect(user_sessions_controller).to match('class User::SessionsController')
  end

  it 'uses view files with option' do
    # Hq files
    hq_admins_view = content('app/views/hq/admins/index.html.haml')
    expect(hq_admins_view).to match('@admins')

    hq_audits_view = content('app/views/hq/audits/index.html.haml')
    expect(hq_audits_view).to match('@audits')

    hq_dashboard_view = content('app/views/hq/dashboard/index.html.haml')
    expect(hq_dashboard_view).to match('current_admin.email')

    hq_passwords_view = content('app/views/hq/passwords/new.html.haml')
    expect(hq_passwords_view).to match('password_path')

    hq_registrations_view = content('app/views/hq/registrations/edit.html.haml')
    expect(hq_registrations_view).to match('admin_registration_path')

    hq_sessions_view = content('app/views/hq/sessions/new.html.haml')
    expect(hq_sessions_view).to match('session_path')

    hq_users_view = content('app/views/hq/users/index.html.haml')
    expect(hq_users_view).to match('@users')

    # User files
    user_dashboard_view = content('app/views/user/dashboard/index.html.haml')
    expect(user_dashboard_view).to match('current_user.email')

    user_passwords_view = content('app/views/user/passwords/new.html.haml')
    expect(user_passwords_view).to match('password_path')

    user_registrations_view = content('app/views/user/registrations/edit.html.haml')
    expect(user_registrations_view).to match('user_registration_path')

    user_sessions_view = content('app/views/user/sessions/new.html.haml')
    expect(user_sessions_view).to match('session_path')

    user_profile_view = content('app/views/user/profile/show.html.haml')
    expect(user_profile_view).to match('@profile')

    # Layouts
    file_exist_test(
      %w[
        app/views/layouts/hq/partials/_dock.html.haml
        app/views/layouts/hq/partials/_breadcrumb.html.haml
        app/views/layouts/hq/partials/_footer.html.haml
        app/views/layouts/hq/partials/_navbar.html.haml
        app/views/layouts/hq/partials/_toolbar.html.haml
        app/views/layouts/hq/partials/_trackers.html.haml
        app/views/layouts/partials/_messages.html.haml
        app/views/layouts/partials/_warnings.html.haml
      ]
    )

    # Devise view files
    file_exist_test(
      %w[
        app/views/devise/confirmations
        app/views/devise/mailer
        app/views/devise/passwords
        app/views/devise/registrations
        app/views/devise/sessions
        app/views/devise/shared
        app/views/devise/unlocks
      ]
    )

    # Welcome view files
    file_exist_test(
      %w[
        app/views/welcome/about.html.haml
        app/views/welcome/contact.html.haml
        app/views/welcome/index.html.haml
      ]
    )

    # Public files
    expect(File).to exist(file_project_path('public/images/favicon.png'))

    # Basic authentication files
    expect(File).to exist(file_project_path('app/controllers/concerns/basic_authentication.rb'))

    application_controller = content('app/controllers/application_controller.rb')
    expect(application_controller).to match('include BasicAuthentication')

    file_exist_test(
      %w[
        .env.sample
        .env.local
        .environments/.env.local
        .environments/.env.production
      ]
    ) do |env|
      expect(content(env)).to match('BASIC_AUTH_IS_ACTIVE=no')
    end

    file_exist_test(%w[.environments/.env.staging]) do |env|
      expect(content(env)).to match('BASIC_AUTH_IS_ACTIVE=yes')
    end
  end

  it 'uses default view files' do
    # Mailer files
    hq_admins_view = content('app/views/admin_mailer/login_info.html.haml')
    expect(hq_admins_view).to match('@admin')
  end

  it 'configure routes file' do
    route_file = content('config/routes.rb')
    expect(route_file).to match('concern :activeable')
  end

  it 'uses model files' do
    admin_model = content('app/models/admin.rb')
    expect(admin_model).to match('login_info_mailer')

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
    force_ssl_test
  end

  it 'uses docker development environment' do

    file_exist_test(
      %w[
        docker-compose.yml
        Dockerfile
        bin/start-app.sh
        bin/start-sidekiq.sh
      ]
    )

    file_exist_test(
      %w[
        .env.sample
        .env.local
        .environments/.env.local
      ]
    ) do |env|
      file = content(env)
      expect(file).to match('REDISTOGO_URL=redis://redis:6379/0')
      expect(file).to match('RACK_ENV=development')
      expect(file).to match('POSTGRESQL_HOST=postgres')
      expect(file).to match('REDIS_HOST=redis')
    end

    file_exist_test(
      %w[
        .environments/.env.staging
        .environments/.env.production
      ]
    ) do |env|
      expect(content(env)).to match('REDISTOGO_URL=')
    end
  end

  it 'uses pronto' do
    pronto_test
  end

  it 'uses guardfile' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'guard'")

    expect(File).to exist(file_project_path('Guardfile'))
  end
end
