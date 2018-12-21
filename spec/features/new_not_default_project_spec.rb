# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration' do
  before(:all) do
    remove_project_directory
    run_cybele(cybele_not_default_parameters)
    setup_app_dependencies
  end

  it 'uses sqlite3 instead of default pg in Gemfile' do
    gemfile_file = content('Gemfile')
    readme_file = content('README.md')
    expect(gemfile_file).not_to match(/^gem 'pg'/)
    expect(gemfile_file).to match(/^gem 'sqlite3'/)
    expect(readme_file).to match(/^# #{app_name.capitalize}/)
    expect(readme_file).not_to match(/^# Docker development/)
    expect(readme_file).not_to match(/^➜ ✗ redis-server/)
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
    file_not_exist_test(
      %w[
        config/sidekiq.yml
        config/sidekiq_schedule.yml
        config/initializers/sidekiq.rb
        lib/tasks/sidekiq.rake
      ]
    )

    routes_file = content('config/routes.rb')
    expect(routes_file).not_to match("^require 'sidekiq/web'")
    expect(routes_file).not_to match("^require 'sidekiq/cron/web'")
  end

  it_behaves_like 'uses responders'

  it_behaves_like 'uses rollbar'

  it_behaves_like 'uses ransack'

  it_behaves_like 'uses will_paginate'

  it_behaves_like 'uses to_xls'

  it_behaves_like 'uses roo'

  it_behaves_like 'uses roo-xls'

  it_behaves_like 'uses write_xlsx'

  it_behaves_like 'uses colorize'

  it_behaves_like 'uses better_errors'

  it_behaves_like 'uses rails-i18n'

  it 'do not use show_for' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'show_for'/)
    file_not_exist_test(
      %w[
        config/initializers/show_for.rb
        config/locales/show_for.en.yml
        config/locales/show_for.tr.yml
      ]
    )
  end

  it_behaves_like 'uses config'

  it_behaves_like 'uses locale_language'

  it_behaves_like 'uses recipient_interceptor'

  it_behaves_like 'uses cybele_version'

  it_behaves_like 'uses bullet'

  it 'do not use simple_form' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'simple_form'/)

    file_not_exist_test(
      %w[
        config/initializers/simple_form.rb
        config/initializers/simple_form_bootstrap.rb
        config/locales/simple_form.en.yml
        config/locales/simple_form.tr.yml
      ]
    )
  end

  it_behaves_like 'has .env files'

  it 'uses mailer' do
    file_exist_test(
      %w[
        config/settings/production.yml
        config/settings/staging.yml
      ]
    )

    mail_test_helper('config/settings.yml')
    mail_test_helper('config/environments/production.rb')
    mail_test_helper('config/environments/staging.rb')
    mail_test_helper('config/environments/development.rb')
  end

  it 'do not use haml' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'haml'/)
    expect(gemfile_file).not_to match(/^gem 'haml-rails'/)

    expect(File).to exist(file_project_path('app/views/layouts/application.html.erb'))
    expect(File).not_to exist(file_project_path('app/views/layouts/application.html.haml'))
  end

  it_behaves_like 'uses devise'

  it_behaves_like 'uses error_pages'

  it_behaves_like 'uses gitignore'

  it 'do not use asset files' do
    gemfile_file = content('Gemfile')
    expect(gemfile_file).not_to match(/^gem 'bootstrap'/)

    file_exist_test(
      %w[
        app/assets/stylesheets/application.css
        app/assets/javascripts/application.js
      ]
    )
    file_not_exist_test(
      %w[
        app/assets/stylesheets/application.css.sass
        app/assets/stylesheets/hq/application.css.sass
        app/assets/javascripts/hq/application.js
      ]
    )
  end

  it 'do not use controller files' do
    expect(File).to exist(file_project_path('app/controllers/application_controller.rb'))

    # Hq files
    file_not_exist_test(
      %w[
        app/controllers/hq/admins_controller.rb
        app/controllers/hq/application_controller.rb
        app/controllers/hq/audits_controller.rb
        app/controllers/hq/dashboard_controller.rb
        app/controllers/hq/passwords_controller.rb
        app/controllers/hq/registrations_controller.rb
        app/controllers/hq/sessions_controller.rb
        app/controllers/hq/users_controller.rb
      ]
    )
    # User files
    file_not_exist_test(
      %w[
        app/controllers/user/application_controller.rb
        app/controllers/user/dashboard_controller.rb
        app/controllers/user/passwords_controller.rb
        app/controllers/user/registrations_controller.rb
        app/controllers/user/sessions_controller.rb
        app/controllers/user/profile_controller.rb
      ]
    )
  end

  it 'do not use view files with option' do
    # Hq files
    file_not_exist_test(
      %w[
        app/views/hq/admins/index.html.haml
        app/views/hq/audits/index.html.haml
        app/views/hq/dashboard/index.html.haml
        app/views/hq/passwords/new.html.haml
        app/views/hq/registrations/edit.html.haml
        app/views/hq/sessions/new.html.haml
        app/views/hq/users/index.html.haml
      ]
    )
    # User files
    file_not_exist_test(
      %w[
        app/views/user/dashboard/index.html.haml
        app/views/user/passwords/new.html.haml
        app/views/user/registrations/edit.html.haml
        app/views/user/sessions/new.html.haml
        app/views/user/profile/show.html.haml
      ]
    )
    # Layouts
    file_not_exist_test(
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
    file_not_exist_test(
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
    file_not_exist_test(
      %w[
        app/views/welcome/about.html.haml
        app/views/welcome/contact.html.haml
        app/views/welcome/index.html.haml
      ]
    )

    # Public files
    expect(File).not_to exist(file_project_path('public/images/favicon.png'))

    # Basic authentication files
    expect(File).not_to exist(file_project_path('app/controllers/concerns/basic_authentication.rb'))

    application_controller = content('app/controllers/application_controller.rb')
    expect(application_controller).not_to match('include BasicAuthentication')

    %w[
      .env.sample
      .env.local
      .environments/.env.local
      .environments/.env.production
    ].each do |env|
      expect(content(env)).not_to match('BASIC_AUTH_IS_ACTIVE=no')
    end

    %w[.environments/.env.staging].each do |env|
      expect(content(env)).not_to match('BASIC_AUTH_IS_ACTIVE=yes')
    end
  end

  it_behaves_like 'uses default view files'

  it 'not configure routes file' do
    route_file = content('config/routes.rb')
    expect(route_file).not_to match('concern :activeable')
  end

  it_behaves_like 'uses model files'

  it_behaves_like 'uses mailer files'

  it_behaves_like 'uses ssl_setting'

  it "don't use docker development environment" do
    file_not_exist_test(
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
      expect(content(env)).not_to match('SIDEKIG_REDIS_URL=redis://redis:6379/0')
    end

    file_exist_test(
      %w[
        .environments/.env.staging
        .environments/.env.production
      ]
    ) do |env|
      expect(content(env)).not_to match('SIDEKIG_REDIS_URL=')
    end
  end

  it_behaves_like 'uses pronto'

  it 'match readme' do
    gemfile_file = content('README.md')
    expect(gemfile_file).to match(file_content('README_SKIP_ALL.md'))
  end
end
