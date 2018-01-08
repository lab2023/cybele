# frozen_string_literal: true

module Cybele
  module Helpers
    module Sidekiq
      def configure_sidekiq
        # Add gems
        append_file('Gemfile', template_content('sidekiq/sidekiq_Gemfile.erb'))

        create_sidekiq_files

        # Add sidekiq routes to routes
        prepend_file 'config/routes.rb',
                     template_content('sidekiq/sidekiq_routes_require.erb')
        inject_into_file 'config/routes.rb',
                         template_content('sidekiq/sidekiq_routes_mount.erb'),
                         after: 'Rails.application.routes.draw do'
        inject_into_file 'config/application.rb',
                         template_content('sidekiq/sidekiq_application.rb.erb'),
                         after: 'class Application < Rails::Application'
      end

      private

      def create_sidekiq_files
        # Initialize files
        files_to_template(
          'sidekiq/sidekiq.rb.erb' => 'config/initializers/sidekiq.rb',
          'sidekiq/sidekiq.rake.erb' => 'lib/tasks/sidekiq.rake',
          'sidekiq/sidekiq.yml.erb' => 'config/sidekiq.yml',
          'sidekiq/sidekiq_schedule.yml.erb' => 'config/sidekiq_schedule.yml',
          'sidekiq/sidekiq_Procfile.erb' => 'Procfile'
        )
      end
    end
  end
end
