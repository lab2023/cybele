# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele('--database=sqlite3 --skip-create-database --skip-sidekiq')
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

    locale_file = content('config/locales/responders.en.yml')
    expect(locale_file).not_to match('# alert:')
    expect(locale_file).to match('create:')
    expect(locale_file).to match('update:')
    expect(locale_file).to match('destroy:')
  end
end
