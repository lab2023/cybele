require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele
  
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
                 :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
                 :desc => 'Skip Test::Unit files'

    def finish_template
      invoke :customization
      super
    end

    def customization
      invoke :customize_gemfile
      invoke :setup_editorconfig
      invoke :setup_ruby_version
      invoke :setup_add_disable_xml_params
      invoke :setup_add_paperclip_aws
      invoke :setup_database
      invoke :remove_files_we_dont_need
      invoke :replace_files
      invoke :install_gems
      invoke :gitignore_files_and_folders
      invoke :setup_bootstrap_sass_coffee
      invoke :copy_vendor_files
      invoke :setup_rails_config
      invoke :setup_staging_environment
      invoke :configure_mail_setting
      invoke :setup_rspec
      invoke :setup_capybara
      invoke :setup_factory_girl
      invoke :setup_simple_form
      invoke :setup_exception_notification
      invoke :setup_exception_notification_to_environments
      invoke :setup_welcome_page
      invoke :setup_devise
      invoke :setup_time_zone
      invoke :setup_bullet_config
      invoke :setup_namespaces
    end

    def customize_gemfile
      build :replace_gemfile
      bundle_command 'install --binstubs=bin/stubs'
    end

    def setup_editorconfig
      say 'Add .editorconfig file'
      build :add_editorconfig
    end

    def setup_ruby_version
      say 'Add .ruby-version file'
      build :add_ruby_version
    end

    def setup_add_disable_xml_params
      say 'Add disable_xml_params.rb file to initilizers'
      build :add_disable_xml_params
    end

    def setup_add_paperclip_aws
      say 'Add paperclip.rb file to initilizers'
      build :add_paperclip_aws
    end

    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_readme_rdoc
    end

    def replace_files
      say 'Replace files'
      build :replace_erb_with_haml
      build :replace_database_yml
    end

    def install_gems
      say 'Install gems'
      say 'Install responder gem'
      build :install_responder_gem
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :replace_database_yml
      end

      build :create_database
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def gitignore_files_and_folders
      build :setup_gitignore_files
      build :setup_gitignore_folders
    end

    def setup_bootstrap_sass_coffee
      say 'Setup bootstrap'
      build :setup_asset_precompile
      build :setup_application_js
      build :convert_application_js_to_coffee
      build :convert_application_css_to_sass
    end

    def copy_vendor_files
      say 'Copy vendor assets'
      build :copy_vendor_assets
    end

    def configure_mail_setting
      say 'Setup mail settings'
      build :configure_action_mailer
      build :configure_smtp
      build :setup_letter_opener
    end

    def setup_rspec
      say 'Generate rspec'
      build :generate_rspec
    end

    def setup_capybara
      say 'Generate capybara'
      build :generate_capybara
    end

    def setup_factory_girl
      say 'Generate factory girl'
      build :generate_factory_girl
    end

    def setup_simple_form
      say 'Generate simple form files'
      build :generate_simple_form
    end

    def setup_exception_notification
      say 'Generate exception notification'
      say 'Do not forget to configure config/initializers/exception_notification.rb file'
      build :generate_exception_notification
    end

    def setup_rails_config
      say 'Generate rails config'
      build :generate_rails_config
    end

    def setup_devise
      say 'Generate devise'
      build :generate_devise_settings
      say 'Adding devise user model'
      build :generate_devise_user
      build :generate_devise_views
    end

    def setup_welcome_page
      say 'Generate Welcome Page'
      build :generate_welcome_page
    end

    def setup_time_zone
      say 'Setup time zone'
      build :set_time_zone
    end

    def setup_hierapolis
      say 'Setup hierapolis'
      build :create_hierapolis_theme
    end

    def setup_sipmle_form_wrapper
      say 'Setup sipmle form wrapper'
      build :replace_simple_form_wrapper
    end

    def setup_exception_notification_to_environments
      say 'Setup exception notification for environments'
      build :add_exception_notification_to_environments
    end

    def install_capistrano
      say 'Setup capistrano'
      build :setup_capistrano
    end

    def setup_capistrano_settings
      say 'Setup capistrano settings'
      build :setup_capistrano_settings
    end

    def setup_recipes
      build :setup_recipes
    end

    def setup_secret_token
      say 'Setup secret token'
      build :update_secret_token
    end

    def setup_bullet_config
      say 'Setup bullet config'
      build :configure_bullet
    end

    def install_show_for
      say 'Setup show_for'
      build :setup_show_for
    end

    def create_dev_rake
      say 'Create dev_rake'
      build :create_dev_rake
    end

    def custom_exception_page
      say 'Setup custom exception pages'
      build :custom_exception_page
    end

    def custom_404
      say 'Setup 404 page'
      build :custom_404
    end

    def add_seeds
      say 'Add seeds main'
      build :add_seeds
    end

    def setup_namespaces
      say 'Generate namespaces'
      build :setup_namespaces
    end

    def copy_all_files
      say 'Copy files'
      build :copy_files
    end

    def setup_git
      say 'Initialize git'
      build :git_commands
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