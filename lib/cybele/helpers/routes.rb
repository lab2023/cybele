# frozen_string_literal: true

module Cybele
  module Helpers
    module Routes
      def configure_routes
        # HQ routes
        replace_in_file 'config/routes.rb',
                        'devise_for :admins',
                        ''

        # User routes
        replace_in_file 'config/routes.rb',
                        'devise_for :users',
                        ''

        inject_into_file 'config/routes.rb', template_content('config/routes.rb.erb'),
                         before: "match '*unmatched_route'"
      end
    end
  end
end
