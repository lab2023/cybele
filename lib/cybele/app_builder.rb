# frozen_string_literal: true

module Cybele
  class AppBuilder < Rails::AppBuilder
    def readme
      template 'README.md.erb', 'README.md', force: true
    end

    def remove_readme_rdoc
      remove_file 'README.rdoc', force: true
    end

    def add_editor_config
      copy_file 'editorconfig', '.editorconfig'
    end

    def add_ruby_version
      copy_file 'ruby-version', '.ruby-version'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb',
               'config/database.yml',
               force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def use_sidekiq
      # Add gems
      append_file('Gemfile', template_content('sidekiq_Gemfile.erb'))

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

      # Add sidekiq routes to routes
      prepend_file 'config/routes.rb',
                   template_content('sidekiq_routes_require.erb')
      inject_into_file 'config/routes.rb',
                       template_content('sidekiq_routes_mount.erb'),
                       after: 'Rails.application.routes.draw do'
    end

    private

    def template_content(file)
      File.read(File.expand_path(find_in_source_paths(file)))
    end
  end
end
