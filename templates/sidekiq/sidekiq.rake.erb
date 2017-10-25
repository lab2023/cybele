# frozen_string_literal: true

namespace :sidekiq do
  desc 'Starts Sidekiq'
  task start: [:environment] do
    config = '-d -C config/sidekiq.yml'
    cmd = Cocaine::CommandLine.new('bundle exec sidekiq', config)
    mes = cmd.run
    if mes == ''
      puts 'Sidekiq started successfully.'
    else
      mes
    end
  end

  desc 'Stops Sidekiq'
  task stop: [:environment] do
    pid_file = 'tmp/pids/sidekiq.pid'
    pid_file = 'tmp/pids/sidekiq_test.pid' if Rails.env.test?
    cmd = Cocaine::CommandLine.new('sidekiqctl', "stop #{pid_file}")
    puts cmd.run
  end

  desc 'Restarts Sidekiq'
  task restart: [:environment] do
    Rake::Task['sidekiq:stop'].execute
    Rake::Task['sidekiq:start'].execute
  end

  desc "Wait until 'busy' queue is finished"
  task wait: :environment do
    Sidekiq::ProcessSet.new.each(&:quiet!)
    sleep(1) unless finished?
  end

  private

  def finished?
    ps = Sidekiq::ProcessSet.new
    ps.size.zero? || ps.detect { |process| process['busy'].zero? }
  end
end
