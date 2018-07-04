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
    class_option :skip_view_files,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip view files. Default: don\'t skip. Dependent: haml, show-for, simple-form'
    class_option :skip_docker,
                 type: :boolean,
                 aliases: nil,
                 default: false,
                 group: :cybele,
                 desc: 'Skip docker development environment. Default: don\'t skip'

    def initialize(*args)
      super
      # Set options
      @options = options.dup

      dependency_control(@options) if @options[:skip_ask]
      ask_questions(@options) unless @options[:skip_ask]
    end

    # :reek:TooManyStatements
    def customize_gemfile
      say 'Customize gem file', :green
      build :add_gems
      bundle_command 'update thor'
      build :add_simple_form_gem unless @options[:skip_simple_form]
      build :add_show_for_gem unless @options[:skip_show_for]
      build :add_haml_gems unless @options[:skip_haml]
      build :add_required_view_gems unless @options[:skip_view_files]
      bundle_command 'install --binstubs=bin/stubs'
    end

    def setup_editor_config
      say 'Add .editor_config file', :green
      build :add_editor_config
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
      say 'Generate .env.* files', :green
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

    def setup_guard
      say 'Generate guard', :green
      build :generate_guard
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

    def setup_bullet_config
      say 'Setup bullet config'
      build :configure_bullet
    end

    def force_ssl
      say 'Add ssl control into staging.rb and production.rb', :green
      build :force_ssl_setting
    end

    def active_storage
      say 'Make active_storage amazon configuration', :green
      build :active_storage_setting
    end

    def setup_devise
      say 'Generate devise'
      build :generate_devise_settings
      say 'Adding devise models'
      build :generate_devise_models
    end

    def configure_mail_setting
      say 'Setup mail settings'
      build :configure_action_mailer
      build :configure_smtp
    end

    def gitignore_files_and_folders
      build :setup_gitignore_files
      build :setup_gitignore_folders
    end

    def configure_error_pages
      say 'Setup custom exception pages and 404 page', :green
      build :configure_error_pages
    end

    def setup_pronto_config
      say 'Setup pronto config', :green
      build :configure_pronto
    end

    def setup_audited
      say 'Setup audited gem', :green
      build :configure_audited
    end

    def customize_app_files
      say 'Customize default files', :green
      build :customize_model_files
      build :customize_mailer_files
      build :customize_default_view_files
    end

    # :reek:TooManyStatements
    def customize_optional_view_files
      return if @options[:skip_view_files]
      say 'Customize optional view files', :green
      build :customize_assets_files
      build :customize_vendor_files
      build :customize_helper_files
      build :customize_view_files_with_option
      build :generate_devise_views
      build :configure_routes
      build :customize_controller_files
      build :add_devise_protect_from_forgery
      build :add_devise_strong_parameter
      build :add_devise_authenticate_admin
      build :configure_basic_authentication
    end

    def docker_development_env
      return if @options[:skip_docker]
      say 'Setup docker development environment', :green
      build :setup_docker_development_env
    end

    def setup_git_and_git_flow
      say 'Initialize git and git flow'
      build :git_and_git_flow_commands
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

    # :reek:TooManyStatements
    def ask_questions(options)
      say 'Ask cybele options', :green
      option_with_ask_limited(options, :database, DATABASES)
      option_with_ask_yes(options, :skip_create_database)
      option_with_ask_yes(options, :skip_sidekiq)
      option_with_ask_yes(options, :skip_simple_form)
      option_with_ask_yes(options, :skip_show_for)
      option_with_ask_yes(options, :skip_haml)
      option_with_ask_yes(options, :skip_view_files)
      option_with_ask_yes(options, :skip_docker)
      options.freeze
      dependency_control(options)
    end

    def option_with_ask_yes(options, key)
      say "==> #{key.to_s.humanize}", :green
      say 'Type for answer yes: y|yes', :green
      say 'Type for answer no: n|no|any character', :yellow

      options[key] = yes?('Ans :', :green)
    end

    def option_with_ask_limited(options, key, limits)
      options[key] = ask("#{key.to_s.humanize} :", limited_to: limits)
    end

    def dependency_control(selected_options)
      arg_checker(selected_options, :skip_view_files, %i[skip_haml skip_show_for skip_simple_form])
    end

    # :reek:TooManyStatements
    def arg_checker(selected_options, option, option_array)
      return if selected_options[option]
      failed = false
      option_array.each do |opt|
        if selected_options[opt]
          puts "Don't #{opt}"
          failed = true
        end
      end
      return unless failed
      puts "#{option} dependency error!"
      puts
      puts 'See --help for more info'
      exit 0
    end
  end
end
