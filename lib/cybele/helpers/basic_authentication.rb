# frozen_string_literal: true

module Cybele
  module Helpers
    module BasicAuthentication
      def configure_basic_authentication
        create_basic_authentication_files
        add_to_settings_yml
        add_to_dotenv_files
        include_basic_authentication_module
        configure_app_name(['config/settings.yml'])
      end

      private

      def create_basic_authentication_files
        # Concern file
        template 'basic_authentication/basic_authentication.rb',
                 'app/controllers/concerns/basic_authentication.rb',
                 force: true
      end

      def add_to_settings_yml
        # Add basic authentication settings to the config/settings.yml file
        append_file 'config/settings.yml',
                    template_content('basic_authentication/basic_authentication_settings.yml.erb')
      end

      def add_to_dotenv_files
        # Add basic authentication env to the all env files
        append_file('env.sample', template_content('basic_authentication/no_basic_authentication.erb'))
        append_file('.env.local', template_content('basic_authentication/no_basic_authentication.erb'))
        append_file('.env.staging', template_content('basic_authentication/yes_basic_authentication.erb'))
        append_file('.env.production', template_content('basic_authentication/no_basic_authentication.erb'))
      end

      def include_basic_authentication_module
        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('basic_authentication/include_module.erb'),
                         after: 'class ApplicationController < ActionController::Base'
      end
    end
  end
end
