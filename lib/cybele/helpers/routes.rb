# frozen_string_literal: true

module Cybele
  module Helpers
    module Routes
      def configure_routes
        # HQ routes
        comment_lines 'config/routes.rb', /devise_for :admins/
        # User routes
        comment_lines 'config/routes.rb', /devise_for :users/

        inject_into_file 'config/routes.rb',
                         template_content('config/routes.rb.erb'),
                         after: 'Rails.application.routes.draw do'
      end
    end
  end
end
