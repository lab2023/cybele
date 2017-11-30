# frozen_string_literal: true

module Cybele
  module Helpers
    module Routes
      def configure_routes
        # HQ routes
        replace_in_file 'config/routes.rb',
                        'devise_for :admins',
                        ''

        inject_into_file 'config/routes.rb', template_content('config/routes.rb.erb'),
                         before: 'if Rails.env.production? || Rails.env.staging?'
      end
    end
  end
end
