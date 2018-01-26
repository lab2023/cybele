# frozen_string_literal: true

module Cybele
  module Helpers
    module Staging
      def setup_staging_environment
        run 'cp config/environments/production.rb config/environments/staging.rb'
      end

      def add_staging_secret_key_to_secrets_yml
        append_file 'config/secrets.yml', template_content('secrets.yml.erb')
      end
    end
  end
end
