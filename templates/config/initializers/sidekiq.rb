Sidekiq.configure_server do |config|
  config.redis = {url: ENV['REDISTOGO_URL'] }
end unless ENV['REDISTOGO_URL'].blank?

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISTOGO_URL']}
end unless ENV['REDISTOGO_URL'].blank?

# Open this if you have scheduled jobs
# schedule_file = 'config/schedule.yml'
# if File.exists?(schedule_file) && Sidekiq.server?
#   Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
# end