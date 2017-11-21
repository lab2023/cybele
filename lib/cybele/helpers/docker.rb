# frozen_string_literal: true

module Cybele
  module Helpers
    module Docker
      def setup_docker_development_env
        # Create docker files
        template 'docker/docker-compose.yml.erb',
                 'docker-compose.yml',
                 force: true
        template 'docker/Dockerfile.erb',
                 'Dockerfile',
                 force: true
        template 'docker/start-app.sh.erb',
                 'bin/start-app.sh',
                 force: true
        template 'docker/start-sidekiq.sh.erb',
                 'bin/start-sidekiq.sh',
                 force: true

        append_file('env.sample', template_content('docker/docker_env_sample.erb'))
        append_file('.env.local', template_content('docker/docker_env_local.erb'))
        append_file('.env.staging', template_content('docker/docker_env_staging.erb'))
        append_file('.env.production', template_content('docker/docker_env_production.erb'))
      end
    end
  end
end
