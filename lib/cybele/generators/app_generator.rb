require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile_new, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppGenerator < Rails::Generators::AppGenerator

    # Internal: Default use postgresql
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
                 :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    # Internal: Default skip Test::Unit
    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
                 :desc => 'Skip Test::Unit files'

    # Internal: Finish template
    def finish_template
      invoke :customization
      super
    end

    # Internal: Customization template
    def customization
      invoke :customize_gemfile
      invoke :setup_database
      invoke :remove_files_we_dont_need
      invoke :replace_files
      invoke :install_gems
      invoke :gitignore_files_and_folders
      invoke :setup_bootstrap_sass_coffee
      invoke :configure_mail_setting
      invoke :setup_rspec
      invoke :setup_capybara
      invoke :setup_simple_form
      invoke :setup_exception_notification
      invoke :setup_welcome_page
      invoke :setup_devise
      invoke :setup_time_zone
    end

    # Internal: Customize gemfile
    def customize_gemfile
      build :replace_gemfile
      bundle_command 'install --binstubs=bin/stubs'
    end

    # Internal: Remove files don't need
    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_readme_rdoc
    end

    # Internal: Replace files
    def replace_files
      say 'Replace files'
      build :replace_erb_with_haml
      build :replace_database_yml
    end

    # Internal: Install gems
    def install_gems
      say 'Install gems'
      say 'Install responder gem'
      build :install_responder_gem
    end

    # Internal: Setup database
    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :replace_database_yml
      end

      build :create_database
    end

    # Internal: Ignore files and folder
    def gitignore_files_and_folders
      build :setup_gitignore_files
      build :setup_gitignore_folders
    end

    # Internal: Setup up bootstrap, sass, coffee
    def setup_bootstrap_sass_coffee
      say 'Setup bootstrap'
      build :setup_asset_precompile
      build :setup_application_js
      build :convert_application_js_to_coffee
      build :convert_application_css_to_sass
    end

    # Internal: Setup mail setting
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

    # Internal: Setup simple_form
    def setup_simple_form
      say 'Generate simple form files'
      build :generate_simple_form
    end

    # Internal: Setup exception notification
    def setup_exception_notification
      say 'Generate exception notification'
      say 'Do not forget to configure config/initializers/exception_notification.rb file'
      build :generate_exception_notification
    end

    # Internal: Setup Rails Config
    def setup_rails_config
      say 'Generate rails config'
      build :generate_rails_config
    end

    # Internal: Setup Devise
    def setup_devise
      say 'Generate devise'
      build :generate_devise_settings
      say 'Adding devise user model'
      build :generate_devise_model, 'user'
      build :generate_devise_views
    end

    # Internal: Setup Welcome Page
    def setup_welcome_page
      say 'Generate Welcome Page'
      build :generate_welcome_page
    end


    def setup_hq_namespace
      say 'Generate hq namespace'
      build :generate_hq_namespace
    end

    # Internal: Setup timezone per user
    def setup_time_zone
      say 'Setup time zone'
      build :set_time_zone
    end


    # Internal: Let's not: We'll bundle manually at the right spot.
    def run_bundle
    end

    protected

    # Internal: We need get_builder class
    def get_builder_class
      Cybele::AppBuilder
    end
  end
end