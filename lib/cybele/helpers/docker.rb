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

        docker_dotenv_files
      end

      private

      def docker_dotenv_files
        append_file('env.sample', template_content('docker/docker_env_sample.erb'))
        %w[local staging production].each do |env|
          append_file(".env.#{env}", template_content("docker/docker_env_#{env}.erb"))
        end
      end
    end
  end
end
