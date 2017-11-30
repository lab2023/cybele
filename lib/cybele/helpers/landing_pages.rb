# frozen_string_literal: true

module Cybele
  module Helpers
    module LandingPages
      def generate_landing_pages
        # Edit application file
        template 'landing_pages/application.html.haml.erb',
                 'app/views/layouts/application.html.haml', force: true

        # Welcome_controller route
        inject_into_file 'config/routes.rb',
                         template_content('landing_pages/landing_route.erb'),
                         before: '  if Rails.env.production? || Rails.env.staging?'

        # Welcome_controller and welcome/index.html.haml
        copy_file 'landing_pages/welcome_controller.rb', 'app/controllers/welcome_controller.rb'
        template 'landing_pages/welcome_index.html.haml.erb', 'app/views/welcome/index.html.haml', force: true
        template 'landing_pages/about.html.haml.erb', 'app/views/welcome/about.html.haml', force: true
        template 'landing_pages/contact.html.haml.erb', 'app/views/welcome/contact.html.haml', force: true

        # Partials
        template 'landing_pages/partials/_warnings.html.haml.erb',
                 'app/views/layouts/partials/_warnings.html.haml', force: true
      end
    end
  end
end