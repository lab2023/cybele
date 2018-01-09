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
        unless @options[:skip_sidekiq]
          template 'docker/start-sidekiq.sh.erb',
                   'bin/start-sidekiq.sh',
                   force: true
        end
        docker_dotenv_files
      end

      private

      def docker_dotenv_files
        docker_dotenv_sidekiq
        %w[.env.local env.sample].each do |env|
          append_template_to_file(env, 'docker/docker_env_local_sample.erb')
        end
        docker_dotenv_sidekiq_local
      end

      def docker_dotenv_sidekiq_local
        return if @options[:skip_sidekiq]
        %w[.env.local env.sample].each do |env|
          append_template_to_file(env, 'docker/docker_env_local_sample_host.erb')
        end
      end

      def docker_dotenv_sidekiq
        return if @options[:skip_sidekiq]
        %w[.env.local env.sample].each do |env|
          append_template_to_file(env, 'docker/docker_env_local_sample_sidekiq.erb')
        end
        %w[staging production].each do |env|
          append_template_to_file(".env.#{env}", 'docker/docker_env_staging_production_sidekiq.erb')
        end
      end
    end
  end
end
