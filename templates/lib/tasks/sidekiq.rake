namespace :sidekiq do

  desc 'Starts Sidekiq'
  task start: [:environment] do
    cmd = Cocaine::CommandLine.new('bundle exec sidekiq', '-C config/sidekiq.yml')
    mes = cmd.run
    if mes == ''
      puts 'Sidekiq started successfully.'
    else
      mes
    end
  end

  desc 'Stops Sidekiq'
  task stop: [:environment] do
    cmd = Cocaine::CommandLine.new('sidekiqctl', 'stop tmp/pids/sidekiq.pid')
    puts cmd.run
  end

  desc 'Restarts Sidekiq'
  task restart: [:environment] do
    Rake::Task['sidekiq:stop'].execute
    Rake::Task['sidekiq:start'].execute
  end

end