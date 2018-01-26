# frozen_string_literal: true

module Cybele
  module Helpers
    module Dotenv
      def configure_dotenv
        # Add dotenv gem
        inject_into_file 'Gemfile',
                         template_content('dotenv/dotenv_Gemfile.erb'),
                         before: "# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'"
        run_bundle

        # Create dotenv files
        files_to_template(
          'dotenv/.env.sample.erb' => '.env.sample',
          'dotenv/.env.local.erb' => '.env.local',
          'dotenv/.env.staging.erb' => '.env.staging',
          'dotenv/.env.production.erb' => '.env.production'
        )
      end
    end
  end
end
