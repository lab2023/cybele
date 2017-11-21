# frozen_string_literal: true

module Cybele
  module Helpers
    module Paperclip
      def configure_paperclip
        # Add gems
        append_file('Gemfile', template_content('paperclip/paperclip_Gemfile.erb'))
        run_bundle

        create_paperclip_files
        configure_app_name(['env.sample', '.env.local', '.env.staging', '.env.production'])
      end

      private

      def create_paperclip_files
        # Initialize file
        template 'paperclip/paperclip.rb.erb',
                 'config/initializers/paperclip.rb',
                 force: true
        # Add paperclip settings to the config/settings.yml file
        append_file 'config/settings.yml',
                    template_content('paperclip/paperclip_settings.yml.erb')

        # Add paperclip env to the all env files
        append_file('env.sample', template_content('paperclip/paperclip_env_sample.erb'))
        append_file('.env.local', template_content('paperclip/paperclip_env_local.erb'))
        append_file('.env.staging', template_content('paperclip/paperclip_env_staging.erb'))
        append_file('.env.production', template_content('paperclip/paperclip_env_production.erb'))
      end
    end
  end
end
