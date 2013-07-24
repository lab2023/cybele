module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # cybele_Gemfile, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppBuilder < Rails::AppBuilder

    # Internal: Overwrite super class readme
    def readme
      template 'README.md.erb', 'README.md', :force => true
    end

    # Internal: Remove README.rdoc file
    def remove_readme_rdoc
      remove_file 'README.rdoc'
    end

    # Internal: Replace gemfile
    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'cybele_Gemfile', 'Gemfile'
    end

    # Internal: Replace config/application.rb file
    def replace_application_rb_file
      remove_file 'config/application.rb'
      copy_file 'config/application.rb', 'config/application.rb'
    end

    # Internal: Replace erb files with html files
    def replace_erb_with_haml
      remove_file 'app/views/layouts/application.html.erb'
      template 'app/views/layouts/application.html.haml.erb', 'app/views/layouts/application.html.haml', :force => true
    end

    # Internal: Replace responders controller template
    def install_responder_gem
      copy_file 'lib/application_responder.rb', 'lib/application_responder.rb'
      remove_file 'app/controllers/application_controller.rb'
      copy_file 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'
      copy_file 'lib/templates/rails/responders_controller/controller.rb', 'lib/templates/rails/responders_controller/controller.rb'
      copy_file 'config/locales/responders.en.yml', 'config/locales/responders.en.yml'
      copy_file 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
    end

    # Internal: Setup database config
    def replace_database_yml
      template 'config/database.yml.erb', 'config/database.yml', :force => true
    end

    # Internal: Create database
    def create_database
      bundle_command 'exec rake db:create'
    end

    # Internal: Setup gitignore files
    def setup_gitignore_files
      remove_file '.gitignore'
      copy_file 'cybele_gitignore', '.gitignore'
    end

    # Internal: Setup gitignore folders
    def setup_gitignore_folders
      %w(
        app/assets/images
        db/migrate
        spec/support
        spec/lib
        spec/models
        spec/views
        spec/controllers
        spec/helpers
      ).each do |dir|
        empty_directory_with_keep_file dir
      end
    end

    # Internal: Setup asset precompile
    # Look for information https://github.com/thomas-mcdonald/bootstrap-sass#rails-4
    def setup_asset_precompile

      config = <<-RUBY


    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.sass.preferred_syntax = :sass
      RUBY

      inject_into_file 'config/application.rb', config, :after => '# config.i18n.default_locale = :de'
    end

    # Interval: Convert application.js to application.js.coffee
    def convert_application_js_to_coffee
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'app/assets/javascripts/application.js.coffee', 'app/assets/javascripts/application.js.coffee'
    end

    # Interval: Convert application.css to application.css.sass
    def convert_application_css_to_sass
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'app/assets/stylesheets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
    end

    # Interval: Configure smtp
    def configure_smtp

      config = <<-RUBY
config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => 'smtp.mandrillapp.com',
      :port                 => 587,
      :enable_starttls_auto => true,
      :user_name            => 'email@email.com', #TODO change this with original
      :password             => 'password',        #TODO change this with original
      :authentication       => 'plain'
  }
      RUBY

      configure_environment 'production', config
    end

    # Interval: Configure action mailer
    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.dev"
      action_mailer_host 'test', "#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"

    end

    # Interval: Setup letter opener
    def  setup_letter_opener
      config = 'config.action_mailer.delivery_method = :letter_opener'
      configure_environment 'development', config
    end

    # Interval: Setup simple form
    def generate_simple_form
      generate 'simple_form:install --bootstrap'
      copy_file 'config/locales/simple_form.tr.yml', 'config/locales/simple_form.tr.yml',
      copy_file 'config/locales/tr.yml', 'config/locales/tr.yml',
    end

    # Internal: Generate exception notification
    #
    # This command generates an initialize file (config/initializers/exception_notification.rb)
    # where you can customize your configurations.
    # https://github.com/smartinez87/exception_notification#rails
    def generate_exception_notification
      generate 'exception_notification:install'
    end

    # Internal: Leftovers
    def leftovers
    end

    # Internal: Setup Rails Config
    def generate_rails_config
      generate 'rails_config:install'
    end

    # Internal: Setup devise
    def generate_devise_settings
      generate 'devise:install'
      gsub_file 'config/initializers/filter_parameter_logging.rb', /:password/, ':password, :password_confirmation'
      gsub_file 'config/initializers/devise.rb', /please-change-me-at-config-initializers-devise@example.com/, 'CHANGEME@example.com'

    end

    # Internal: Generate devise model
    def generate_devise_model(model_name)
      generate "devise #{model_name} name:string"
      generate_devise_strong_parameters(model_name)
      remove_file 'config/locales/devise.en.yml'
    end

    # Internal: Generate devise views
    def generate_devise_views
      # generate "devise:views"
      directory 'app/views/devise', 'app/views/devise'
    end

    # Internal: Generate Welcome Page
    def generate_welcome_page
      copy_file 'app/controllers/welcome_controller.rb', 'app/controllers/welcome_controller.rb'
      template 'app/views/welcome/index.html.haml.erb', 'app/views/welcome/index.html.haml', :force => true
      route "root to: 'welcome#index'"
    end

    def set_time_zone
      add_set_user_time_zone_method_to_application_controller
      add_time_zone_to_user
    end


    private

    # Internal: Set action mailer hostname
    #
    # rail_env  - rails env like development, text, production
    # host      - domain.dev, domain.com or example.com
    #
    # Returns nothing
    def action_mailer_host(rails_env, host)

      config = <<-RUBY
  # Mail Setting
  config.action_mailer.default_url_options = { :host => '#{host}' }
      RUBY

      configure_environment(rails_env, config)
    end

    # Internal: Set configure environment
    #
    # rail_env  - rails env like development, text, production
    # config    - config string which will add to rails_env file
    #
    # Return nothing
    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb", "\n\n  #{config}", before: "\nend")
    end

    # Setup strong params for devise
    def generate_devise_strong_parameters(model_name)
      create_sanitizer_lib(model_name)
      create_sanitizer_initializer(model_name)
      devise_parameter_sanitizer(model_name)
    end


    # Internal: Create devise ParameterSanitizer library
    def create_sanitizer_lib(model_name)
      create_file "lib/#{model_name.parameterize}_sanitizer.rb", <<-CODE
class #{model_name.classify}::ParameterSanitizer < Devise::ParameterSanitizer
  private
  def sign_up
    default_params.permit(:name, :email, :password, :password_confirmation) # TODO add other params here
  end
end
      CODE
    end

    # Internal: Create devise ParameterSanitizer library initializer
    def create_sanitizer_initializer(model_name)
      path = "#"
      path << "{Rails.application.root}"
      path << "/lib/#{model_name.parameterize}_sanitizer.rb"
      initializer 'sanitizers.rb', <<-CODE
require "#{path}"
      CODE
    end

    # Internal: Add devise_parameter_sanitizer method to app/controller/applications_controller.rb
    def devise_parameter_sanitizer(model_name)
      inject_into_file 'app/controllers/application_controller.rb', :after => 'protect_from_forgery with: :exception' do <<-CODE

  protected

  def devise_parameter_sanitizer
    if resource_class == #{model_name.classify}
      #{model_name.classify}::ParameterSanitizer.new(#{model_name.classify}, :#{model_name.parameterize}, params)
    else
      super # Use the default one
    end
  end
      CODE
      end
    end

    # Internal: Generate migration for add time_zone to User model
    def add_time_zone_to_user
      say 'Add time_zone to User model'
      generate 'migration AddTimeZoneToUser time_zone:string -s'
    end

    # Internal: Add set_user_time_zone method to app/controller/applications_controller.rb
    def add_set_user_time_zone_method_to_application_controller
      say 'Add set_user_time_zone method to application controller'
      inject_into_file 'app/controllers/application_controller.rb', :after => 'protected' do <<-CODE

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in? && current_user.time_zone.present?
  end

      CODE
      end
      inject_into_file 'app/controllers/application_controller.rb', :after => 'class ApplicationController < ActionController::Base' do <<-CODE

  before_filter :set_user_time_zone

      CODE
      end
    end
  end
end
