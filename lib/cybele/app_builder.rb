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
      copy_file 'config/initializers/mail.rb', 'config/initializers/mail.rb'

      prepend_file 'config/environments/production.rb',
                   "require Rails.root.join('config/initializers/mail')\n"

      config = <<-RUBY


  # Mail Settings
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = MAIL_SETTING
      RUBY

      inject_into_file 'config/environments/production.rb', config,
                       :after => 'config.action_mailer.raise_delivery_errorsraise_delivery_errors = false'
    end

    # Interval: Configure action mailer
    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.dev"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'production', "#{app_name}.com"
    end

    # Interval: Setup letter opener
    def  setup_letter_opener
      config = 'config.action_mailer.delivery_method = :letter_opener'
      configure_environment 'development', config
    end

    # Internal: Leftovers
    def leftovers
    end

    private

    # Internal: Set action mailer hostname
    #
    # rail_env  - rails env like development, text, production
    # host      - domain.dev, domain.com or example.com
    #
    # Returns nothing
    def action_mailer_host(rails_env, host)
      config = "config.action_mailer.default_url_options = { host: '#{host}' }"
      configure_environment(rails_env, config)
    end

    # Internal: Set configure environment
    #
    # rail_env  - rails env like development, text, production
    # config    - config string which will add to rails_env file
    #
    # Return nothing
    def configure_environment(rails_env, config)
      inject_into_file(
          "config/environments/#{rails_env}.rb",
          "\n\n  #{config}",
          before: "\nend"
      )
    end
  end
end
