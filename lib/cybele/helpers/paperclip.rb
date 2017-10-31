# frozen_string_literal: true

module Cybele
  module Helpers
    module Paperclip
      def configure_paperclip
        # Add gems
        append_file('Gemfile', template_content('paperclip/paperclip_Gemfile.erb'))
        run_bundle

        create_paperclip_files
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
        gsub_file 'env.sample', /<%= app_name %>/, app_name
        append_file('.env.local', template_content('paperclip/paperclip_env_local.erb'))
        gsub_file '.env.local', /<%= app_name %>/, app_name
        append_file('.env.staging', template_content('paperclip/paperclip_env_staging.erb'))
        gsub_file '.env.staging', /<%= app_name %>/, app_name
        append_file('.env.production', template_content('paperclip/paperclip_env_production.erb'))
        gsub_file '.env.production', /<%= app_name %>/, app_name
      end
    end
  end
end
