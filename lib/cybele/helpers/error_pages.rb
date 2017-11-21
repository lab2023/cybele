# frozen_string_literal: true

module Cybele
  module Helpers
    module ErrorPages
      def configure_error_pages
        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('error_pages/error_control.erb'),
                         after: 'class ApplicationController < ActionController::Base'

        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('error_pages/error_method.erb'),
                         after: 'protect_from_forgery with: :exception'

        inject_into_file 'config/routes.rb',
                         template_content('error_pages/error_route.erb'),
                         before: /^end/

        create_error_pages_files
      end

      private

      def create_error_pages_files
        # Server Error
        template 'error_pages/internal_server_error.html.haml',
                 'app/views/errors/internal_server_error.html.haml',
                 force: true

        # Not Found Error
        template 'error_pages/not_found.html.haml',
                 'app/views/errors/not_found.html.haml',
                 force: true
      end
    end
  end
end
