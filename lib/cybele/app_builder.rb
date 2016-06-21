module Cybele

  class AppBuilder < Rails::AppBuilder

    def readme
      template 'README.md.erb', 'README.md', force: true
    end

    def remove_readme_rdoc
      remove_file 'README.rdoc'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'cybele_Gemfile', 'Gemfile'
    end

    def add_editorconfig
      copy_file 'editorconfig', '.editorconfig'
    end

    def add_ruby_version
      copy_file 'ruby-version', '.ruby-version'
    end

    def add_disable_xml_params
      copy_file 'config/initializers/disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def add_paperclip_aws
      copy_file 'config/initializers/paperclip.rb', 'config/initializers/paperclip.rb'
    end

    def replace_erb_with_haml
      remove_file 'app/views/layouts/application.html.erb'
      template 'app/views/layouts/application.html.haml.erb', 'app/views/layouts/application.html.haml', force: true
    end

    def copy_rake_files
    end

    def install_responder_gem
      copy_file 'lib/application_responder.rb', 'lib/application_responder.rb'
      remove_file 'app/controllers/application_controller.rb'
      copy_file 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'
      copy_file 'app/controllers/concerns/basic_authentication.rb', 'app/controllers/concerns/basic_authentication.rb'
      copy_file 'lib/templates/rails/responders_controller/controller.rb', 'lib/templates/rails/responders_controller/controller.rb'
      copy_file 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
    end

    def replace_database_yml
      template 'config/database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def setup_gitignore_files
      remove_file '.gitignore'
      copy_file 'cybele_gitignore', '.gitignore'
    end

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

    def setup_asset_precompile
      config = <<-RUBY
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.sass.preferred_syntax = :sass
    config.i18n.default_locale = :tr
    config.time_zone = 'Istanbul'
    config.i18n.fallbacks = true
    config.active_job.queue_adapter = :sidekiq
      RUBY
      inject_into_file 'config/application.rb', config, after: '# config.i18n.default_locale = :de'
    end

    def convert_application_js_to_coffee
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'app/assets/javascripts/application.js.coffee', 'app/assets/javascripts/application.js.coffee'
    end

    def convert_application_css_to_sass
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'app/assets/stylesheets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
    end

    def copy_vendor_assets
      directory 'vendor/assets', 'vendor/assets'
    end

    def configure_smtp
      remove_file 'config/settings/production.yml'
      copy_file 'config/settings/production.yml', 'config/settings/production.yml'
      copy_file 'config/settings/staging.yml', 'config/settings/staging.yml'

      config = <<-RUBY
Mail.register_interceptor RecipientInterceptor.new(Settings.email.sandbox, subject_prefix: '[STAGING]')
      RUBY
      configure_environment 'staging', config

      config = <<-RUBY
config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.smtp_settings = {
      address: Settings.smtp.address,
      port: Settings.smtp.port,
      enable_starttls_auto: Settings.smtp.enable_starttls_auto,
      user_name: Settings.smtp.user_name,
      password: Settings.smtp.password,
      authentication: Settings.smtp.authentication
  }
      RUBY
      configure_environment 'production', config
      configure_environment 'staging', config
    end

    def configure_bullet
      config = <<-RUBY
config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = false
  end
      RUBY
      configure_environment 'development', config
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'
      config = <<-YML
email:
  sandbox: sandbox@#{app_name}.com
  noreply: no-reply@#{app_name}.com
  admin: admin@#{app_name}.com

basic_auth:
  username: #{app_name}
  password: #{app_name}

sidekiq:
  username: #{app_name}
  password: #{app_name}

root_path: <%= ENV['ROOT_PATH'] %>

smtp:
  address: <%= ENV['SMTP_ADDRESS'] %>
  port: 587
  enable_starttls_auto: true
  user_name: <%= ENV['SMTP_USER_NAME'] %>
  password: <%= ENV['SMTP_PASSWORD'] %>
  authentication: 'plain'

AWS:
  S3:
    bucket: <%= ENV['S3_BUCKET_NAME'] %>
    access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
    secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
    aws_url: http://<%= ENV['AWS_RAW_URL'] %>
    aws_raw_url: <%= ENV['AWS_RAW_URL'] %>
    # Bucket region should be ireland for this setting
    end_point: s3-eu-west-1.amazonaws.com
      YML
      prepend_file 'config/settings.yml', config
    end

    def configure_action_mailer
      action_mailer_host 'development'
      action_mailer_host 'staging'
      action_mailer_host 'production'
    end

    def  setup_letter_opener
      config = 'config.action_mailer.delivery_method = :letter_opener'
      configure_environment 'development', config
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def generate_capybara
      inject_into_file 'spec/spec_helper.rb', after: "require 'rspec/autorun'" do <<-CODE
require 'capybara/rspec'
      CODE
      end
      inject_into_file 'spec/spec_helper.rb', after: '  config.order = "random"' do <<-CODE
  # Capybara DSL
  config.include Capybara::DSL
      CODE
      end
    end

    def generate_factory_girl
      inject_into_file 'spec/spec_helper.rb', after: '  config.include Capybara::DSL' do <<-CODE
  # Factory girl
  config.include FactoryGirl::Syntax::Methods
      CODE
      end
    end

    def generate_simple_form
      generate 'simple_form:install --bootstrap  --force'
      copy_file 'config/locales/simple_form.tr.yml', 'config/locales/simple_form.tr.yml'
      copy_file 'config/locales/tr.yml', 'config/locales/tr.yml'
    end

    def generate_exception_notification
      generate 'exception_notification:install'
      generate 'rollbar your_token'
    end

    def add_exception_notification_to_environments
      config = <<-CODE
config.middleware.use ExceptionNotification::Rack, 
  email: {
    email_prefix: "[#{app_name}]",
    sender_address: %{"Notifier" <notifier@#{app_name}.com>},
    exception_recipients: %w{your_email@address.com}
  }
      CODE
      configure_environment('production', config)
      configure_environment('staging', config)
      inject_into_file 'config/initializers/exception_notification.rb', before: 'config.add_notifier :email, {' do <<-RUBY
        unless Rails.env == 'development'
      RUBY
      end
      inject_into_file 'config/initializers/exception_notification.rb', before: '# Campfire notifier sends notifications to your Campfire room.' do <<-RUBY
        end
      RUBY
      end
    end

    def generate_rails_config
      generate 'rails_config:install'
    end

    def generate_devise_settings
      generate 'devise:install'
      gsub_file 'config/initializers/filter_parameter_logging.rb', /:password/, ':password, :password_confirmation'
      gsub_file 'config/initializers/devise.rb', /please-change-me-at-config-initializers-devise@example.com/, "no-reply@#{app_name}.com"
      inject_into_file 'config/initializers/devise.rb', after: "# config.mailer = 'Devise::Mailer'\n" do <<-RUBY
  Devise::Mailer.layout 'mailer'
      RUBY
      end
    end

    def generate_devise_user
      generate 'devise User name:string surname:string is_active:boolean'
      generate_devise_strong_parameters('user')
      remove_file 'config/locales/devise.en.yml'
    end

    def generate_devise_views
      directory 'app/views/devise', 'app/views/devise'
    end

    def generate_welcome_page
      copy_file 'app/controllers/welcome_controller.rb', 'app/controllers/welcome_controller.rb'
      template 'app/views/welcome/index.html.haml.erb', 'app/views/welcome/index.html.haml', force: true
    end

    def setup_namespaces
      generate 'devise Admin name:string surname:string is_active:boolean'

      directory 'app/controllers/hq', 'app/controllers/hq'
      directory 'app/views/hq', 'app/views/hq'

      # User controllers
      directory 'app/controllers/user', 'app/controllers/user'
      directory 'app/views/user', 'app/views/user'

    end

    def set_time_zone
      add_time_zone_to_user
    end

    def create_hierapolis_theme
      remove_file 'lib/templates/rails/responders_controller/controller.rb'
      remove_file 'lib/templates/haml/scaffold/_form.html.haml'
      generate 'hierapolis:install'
    end

    def replace_simple_form_wrapper
      remove_file 'config/initializers/simple_form.rb'
      remove_file 'config/initializers/simple_form_bootstrap.rb'

      copy_file 'config/initializers/simple_form.rb', 'config/initializers/simple_form.rb'
      copy_file 'config/initializers/simple_form_bootstrap.rb', 'config/initializers/simple_form_bootstrap.rb'
    end
 
    def setup_capistrano
      run 'bundle exec cap install'
    end

    def setup_capistrano_settings 
      run 'rm config/deploy.rb'
      # Copy teplates/config/deploy.rb to app directory
      copy_file 'config/deploy.rb', 'config/deploy.rb'
      # Change my_app_name string in the deploy.rb file with app_name that is created 
      gsub_file 'config/deploy.rb', /my_app_name/, "#{app_name}"

      inject_into_file 'Capfile', after: "require 'capistrano/deploy'\n" do <<-RUBY
require 'capistrano/rails'
require 'capistrano/bundler'
require 'sshkit/sudo'
require 'capistrano/maintenance'
      RUBY
      end

      append_to_file 'config/deploy/production.rb' do
        'server "example.com", user: "#{fetch(:local_user)}", roles: %w{app db web}, primary: true, port: 22
set :rails_env, "production"
set :branch, "master"
set :project_domain, "example.com"'
      end
      append_to_file 'config/deploy/staging.rb' do 
        'server "staging.example.com", user: "#{fetch(:local_user)}", roles: %w{app db web}, primary: true, port: 22 
set :rails_env, "staging"
set :branch, "develop"
set :project_domain, "staging.example.com"'
      end
    end

    # Nor using  
    def setup_recipes 
      generate 'recipes_matic:install'
    end

    def update_secret_token
      remove_file 'config/initializers/secret_token.rb'
      template 'config/initializers/secret_token.erb', 'config/initializers/secret_token.rb'
    end

    def setup_show_for
      copy_file 'config/initializers/show_for.rb', 'config/initializers/show_for.rb'
    end

    def create_dev_rake
    end

    def custom_exception_page
      copy_file 'app/views/errors/internal_server_error.html.haml', 'app/views/errors/internal_server_error.html.haml'
    end

    def custom_404
      copy_file 'app/views/errors/not_found.html.haml', 'app/views/errors/not_found.html.haml'
    end

    def add_seeds
      say 'Add seeds'
      inject_into_file 'db/seeds.rb', after: "#   Mayor.create(name: 'Emanuel', city: cities.first)\n" do <<-RUBY
      Admin.create(email: "admin@#{app_name}.com", name: 'Admin', surname: 'Admin', password: '12341234', password_confirmation: '12341234')
      RUBY
      end      
    end

    # Copy files
    def copy_files
      # Locale files
      say 'Coping files..'
      remove_file 'config/locales/en.yml'
      remove_file 'config/locales/simple_form.en.yml'
      directory 'config/locales', 'config/locales'

      # Model files
      remove_file 'app/models/admin.rb'
      remove_file 'app/models/user.rb'
      directory 'app/models', 'app/models'

      # Route file
      say 'Restore routes.rb'
      remove_file 'config/routes.rb'
      template 'config/routes.erb', 'config/routes.rb'

      # Hq layout files
      say 'Set hq layouts'
      remove_file 'app/views/layouts/hq/application.html.haml'
      template 'app/views/layouts/hq/application.html.haml.erb', 'app/views/layouts/hq/application.html.haml', force: true
      remove_file 'app/views/layouts/login.html.haml'
      template 'app/views/layouts/hq/login.html.haml.erb', 'app/views/layouts/hq/login.html.haml', force: true

      # Mailer layout files
      template 'app/views/layouts/mailer.html.haml.erb', 'app/views/layouts/mailer.html.haml', force: true
      copy_file 'app/views/layouts/mailer.text.haml', 'app/views/layouts/mailer.text.haml'

      # Hq assets files
      remove_file 'app/assets/javascripts/hq/application.js.coffee'
      remove_file 'app/assets/stylesheets/hq/application.css.sass'
      directory 'app/assets', 'app/assets'

      # Partial files in layouts folder
      directory 'app/views/layouts/partials', 'app/views/layouts/partials'

      # Root folder files
      copy_file 'cybele_version.txt', 'VERSION.txt'
      directory 'public/images', 'public/images'
      template '.env.local.erb', '.env.local', force: true
      template '.env.production.erb', '.env.production', force: true
      template '.env.staging.erb', '.env.staging', force: true
      template 'env.sample.erb', 'env.sample', force: true

      # Library files
      directory 'lib/tasks', 'lib/tasks'
      directory 'lib/data', 'lib/data'

      # Config files
      copy_file 'config/initializers/sidekiq.rb', 'config/initializers/sidekiq.rb'
      copy_file 'config/initializers/devise_async.rb', 'config/initializers/devise_async.rb'
      copy_file 'config/schedule.yml', 'config/schedule.yml'
      copy_file 'config/sidekiq.yml', 'config/sidekiq.yml'
    end

    private

    def action_mailer_host(rails_env)
      config = <<-RUBY
# Mail Setting
  config.action_mailer.default_url_options = { host: ENV['ROOT_PATH'] }
      RUBY
      configure_environment(rails_env, config)
    end

    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb", "\n\n  #{config}", before: "\nend")
    end

    def generate_devise_strong_parameters(model_name)
      create_sanitizer_lib(model_name)
      create_sanitizer_initializer(model_name)
      devise_parameter_sanitizer(model_name)
    end

    def create_sanitizer_lib(model_name)
      create_file "lib/#{model_name.parameterize}_sanitizer.rb", <<-CODE
class #{model_name.classify}::ParameterSanitizer < Devise::ParameterSanitizer
  private
  def sign_up
    default_params.permit(:name, :surname, :email, :password, :password_confirmation, :time_zone) # TODO add other params here
  end
end
      CODE
    end

    def create_sanitizer_initializer(model_name)
      path = "#"
      path << "{Rails.application.root}"
      path << "/lib/#{model_name.parameterize}_sanitizer.rb"
      initializer 'sanitizers.rb', <<-CODE
require "#{path}"
      CODE
    end

    def devise_parameter_sanitizer(model_name)
      inject_into_file 'app/controllers/application_controller.rb', after: 'protect_from_forgery with: :exception' do <<-CODE
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

    def add_time_zone_to_user
      say 'Add time_zone to User model'
      generate 'migration AddTimeZoneToUser time_zone:string -s'
    end


  end
end
