# frozen_string_literal: true

module Cybele
  module Helpers
    module Paperclip
      def configure_paperclip
        # Add gems
        append_file('Gemfile', template_content('paperclip/paperclip_Gemfile.erb'))
        run_bundle

        create_paperclip_files
        configure_app_name(%w[env.sample .env.local .env.staging .env.production])
      end

      private

      def create_paperclip_files
        # Initialize file
        template 'paperclip/paperclip.rb.erb',
                 'config/initializers/paperclip.rb',
                 force: true
        # Add paperclip settings to the config/settings.yml file
        append_template_to_files(
          'config/settings.yml' => 'paperclip/paperclip_settings.yml.erb',
          'env.sample' => 'paperclip/paperclip_env_sample.erb',
          '.env.local' => 'paperclip/paperclip_env_local.erb',
          '.env.staging' => 'paperclip/paperclip_env_staging.erb',
          '.env.production' => 'paperclip/paperclip_env_production.erb'
        )
      end
    end
  end
end
