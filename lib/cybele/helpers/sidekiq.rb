# frozen_string_literal: true

module Cybele
  module Helpers
    module Sidekiq
      def configure_sidekiq
        # Add gems
        append_file('Gemfile', template_content('sidekiq_Gemfile.erb'))

        create_sidekiq_files

        # Add sidekiq routes to routes
        prepend_file 'config/routes.rb',
                     template_content('sidekiq_routes_require.erb')
        inject_into_file 'config/routes.rb',
                         template_content('sidekiq_routes_mount.erb'),
                         after: 'Rails.application.routes.draw do'
      end

      private

      def create_sidekiq_files
        # Initialize files
        template 'sidekiq.rb.erb',
                 'config/initializers/sidekiq.rb',
                 force: true
        # Add tasks
        template 'sidekiq.rake.erb',
                 'lib/tasks/sidekiq.rake',
                 force: true

        # Add sidekiq.yml
        template 'sidekiq.yml.erb',
                 'config/sidekiq.yml',
                 force: true

        # Add sidekiq_schedule.yml
        template 'sidekiq_schedule.yml.erb',
                 'config/sidekiq_schedule.yml',
                 force: true
      end
    end
  end
end
