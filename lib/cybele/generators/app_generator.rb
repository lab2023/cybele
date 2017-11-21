# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele
  class AppGenerator < Rails::Generators::AppGenerator
    @options = nil

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
    # Ask cybele options
    class_option :skip_ask,
                 type: :boolean,
                 aliases: nil,
                 default: true,
                 group: :cybele,
                 desc: 'Skip ask for cybele options. Default: skip'
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
    class_option :skip_simple_form,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip simple_form integration. Default: don\'t skip'
    class_option :skip_show_for,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip show_for integration. Default: don\'t skip'
    class_option :skip_haml,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip haml and haml-rails integration. Default: don\'t skip'

    def initialize(*args)
      super
      # Set options
      @options = options.dup

      return if @options[:skip_ask]

      say 'Ask cybele options', :green
      option_with_ask_limited(:database, DATABASES)
      option_with_ask_yes(:skip_create_database)
      option_with_ask_yes(:skip_sidekiq)
      option_with_ask_yes(:skip_simple_form)
      option_with_ask_yes(:skip_show_for)
      option_with_ask_yes(:skip_haml)
      @options.freeze
    end

    def customize_gemfile
      say 'Customize gem file', :green
      build :add_gems
      build :add_simple_form_gem unless @options[:skip_simple_form]
      build :add_show_for_gem unless @options[:skip_show_for]
      build :add_haml_gems unless @options[:skip_haml]
      bundle_command 'install --binstubs=bin/stubs'
    end

    def setup_editor_config
      say 'Add .editor_config file', :green
      build :add_editor_config
    end

    def setup_ruby_version
      say 'Add .ruby-version file', :green
      build :add_ruby_version
    end

    def setup_cybele_version
      say 'Add .VERSION.txt file', :green
      build :add_cybele_version
    end

    def remove_files_we_dont_need
      say 'Remove files we don\'t need', :green
      build :remove_readme_rdoc
    end

    def setup_config
      say 'Generate config', :green
      build :generate_config
    end

    def setup_dotenv
      say 'Generate env.sample and .env files', :green
      build :configure_dotenv
    end

    def setup_database
      if @options[:database] == 'postgresql'
        say 'Set up postgresql template', :green
        build :use_postgres_config_template
      end

      return if @options[:skip_create_database]
      say 'Create database', :green
      build :create_database
    end

    def setup_sidekiq
      return if @options[:skip_sidekiq]
      say 'Setting up sidekiq', :green
      build :configure_sidekiq
    end

    def setup_responders
      say 'Setting up responders', :green
      build :configure_responders
    end

    def setup_staging_environment
      say 'Setting up the staging environment', :green
      build :setup_staging_environment
    end

    def configure_recipient_interceptor
      say 'Setup mail settings with recipient_interceptor in staging', :green
      build :configure_recipient_interceptor
    end

    def setup_rollbar
      say 'Generate rollbar', :green
      build :generate_rollbar
    end

    def configure_locale_language
      say 'Configure locale', :green
      build :configure_locale_language
    end

    def setup_show_for
      return if @options[:skip_show_for]
      say 'Generate show_for', :green
      build :configure_show_for
    end

    def setup_simple_form
      return if @options[:skip_simple_form]
      say 'Setting up simple_form', :green
      build :configure_simple_form
    end

    def setup_haml
      return if @options[:skip_haml]
      say 'Setting up haml and generate haml-rails', :green
      build :configure_haml
    end

    def add_staging_secret_key
      say 'Add staging secret key to secret.yml file', :green
      build :add_staging_secret_key_to_secrets_yml
    end

    def setup_bullet_config
      say 'Setup bullet config'
      build :configure_bullet
    end

    def force_ssl
      say 'Add ssl control into staging.rb and production.rb', :green
      build :force_ssl_setting
    end

    def setup_paperclip_and_add_aws
      say 'Setting up paperclip, editing settings.yml and env files', :green
      build :configure_paperclip
    end

    def setup_devise
      say 'Generate devise'
      build :generate_devise_settings
      say 'Adding devise user model'
      build :generate_devise_user
      build :generate_devise_views
      say 'Generate devise'
    end

    def configure_mail_setting
      say 'Setup mail settings'
      build :configure_action_mailer
      build :configure_smtp
      build :setup_letter_opener
    end

    def gitignore_files_and_folders
      build :setup_gitignore_files
      build :setup_gitignore_folders
    end

    def goodbye
      say 'Congratulations! That\'s all...', :green
    end

    def self.banner
      "cybele #{arguments.map(&:usage).join(' ')} [options]"
    end

    protected

    def get_builder_class
      Cybele::AppBuilder
    end

    private

    def option_with_ask_yes(key)
      say "==> #{key.to_s.humanize}", :green
      say 'Type for answer yes: y|yes', :green
      say 'Type for answer no: n|no|any character', :yellow

      @options = @options.merge(key => yes?('Ans :', :green))
    end

    def option_with_ask_limited(key, limits)
      @options = @options.merge(key => ask("#{key.to_s.humanize} :", limited_to: limits))
    end
  end
end
