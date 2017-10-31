# frozen_string_literal: true

module Cybele
  module Helpers
    module Dotenv
      def configure_dotenv
        # Add dotenv gem
        inject_into_file 'Gemfile', template_content('dotenv/dotenv_Gemfile.erb'),
                         before: "# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'"
        run_bundle

        # Create dotenv files
        template 'dotenv/env.sample.erb',
                 'env.sample',
                 force: true
        template 'dotenv/.env.local.erb',
                 '.env.local',
                 force: true
        template 'dotenv/.env.staging.erb',
                 '.env.staging',
                 force: true
        template 'dotenv/.env.production.erb',
                 '.env.production',
                 force: true
      end
    end
  end
end
