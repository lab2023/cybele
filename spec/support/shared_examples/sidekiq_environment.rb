# frozen_string_literal: true

shared_examples 'uses sidekiq' do
  it do
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
end
