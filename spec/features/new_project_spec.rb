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
end