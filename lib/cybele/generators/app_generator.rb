# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele
  class AppGenerator < Rails::Generators::AppGenerator
    # Default settings
    class_option :database,
                 type: :string,
                 aliases: '-d',
                 default: 'postgresql',
                 desc: "Configure for selected database (options: #{DATABASES.join('/')})"
    class_option :version,
                 type: :boolean,
                 aliases: '-v',
                 group: :cybele,
                 desc: 'Show cybele version number and quit'
    class_option :help,
                 type: :boolean,
                 aliases: '-h',
                 group: :cybele,
                 desc: 'Show cybele help message and quit'
    # Custom settings
    class_option :skip_create_database,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip create database. Default: don\'t skip'
    class_option :skip_sidekiq,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip sidekiq integration. Default: don\'t skip'

    def setup_editor_config
      say 'Add .editor_config file'
      build :add_editor_config
    end

    def setup_ruby_version
      say 'Add .ruby-version file'
      build :add_ruby_version
    end

    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_readme_rdoc
    end

    def setup_database
      say 'Setting up database'
      build :use_postgres_config_template if options[:database] == 'postgresql'
      if options[:skip_create_database]
        say 'don\'t create database'
      else
        build :create_database
      end
    end

    def setup_sidekiq
      say 'Setting up sidekiq'
      if options[:skip_sidekiq]
        say 'don\'t use sidekiq'
      else
        build :use_sidekiq
      end
    end

    def goodbye
      say 'Congratulations! That\'s all...'
    end

    protected

    def get_builder_class
      Cybele::AppBuilder
    end
  end
end
