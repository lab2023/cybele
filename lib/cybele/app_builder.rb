# frozen_string_literal: true

module Cybele
  class AppBuilder < Rails::AppBuilder
    include Cybele::Helpers
    include Cybele::Helpers::Staging
    include Cybele::Helpers::Sidekiq
    include Cybele::Helpers::Responders
    include Cybele::Helpers::SimpleForm
    include Cybele::Helpers::Dotenv
    include Cybele::Helpers::RecipientInterceptor
    include Cybele::Helpers::ShowFor
    include Cybele::Helpers::Haml
    include Cybele::Helpers::LocaleLanguage
    include Cybele::Helpers::Paperclip
    include Cybele::Helpers::Devise

    def readme
      template 'README.md.erb',
               'README.md',
               force: true
    end

    def remove_readme_rdoc
      remove_file 'README.rdoc',
                  force: true
    end

    def add_gems
      # Add gems
      append_file('Gemfile', template_content('Gemfile.erb'))
    end

    def add_editor_config
      copy_file 'editorconfig', '.editorconfig'
    end

    def add_ruby_version
      copy_file 'ruby-version', '.ruby-version'
    end

    def add_cybele_version
      copy_file 'VERSION.txt', 'VERSION.txt'
      run 'ln -s ../VERSION.txt public/VERSION.txt'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb',
               'config/database.yml',
               force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def generate_config
      generate 'config:install'
      run 'cp config/settings/development.yml config/settings/staging.yml'
      append_file('config/settings.yml', template_content('settings.yml.erb'))
    end

    def generate_rollbar
      generate 'rollbar'
    end

    def configure_bullet
      configure_environment 'development', template_content('bullet/bullet_settings.rb.erb')
    end

    private

    def generate_devise_strong_parameters(model_name)
      create_sanitizer_lib(model_name)
      create_sanitizer_initializer(model_name)
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
      path = '#'
      path += '{Rails.application.root}'
      path += "/lib/#{model_name.parameterize}_sanitizer.rb"
      initializer 'sanitizers.rb', <<-CODE
      require "#{path}"
      CODE
    end

    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb", "\n#{config}", before: "\nend")
    end
  end
end
