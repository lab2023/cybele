# frozen_string_literal: true

module Cybele
  module Helpers
    module Responders
      def configure_responders
        # Add gems
        append_file('Gemfile', template_content('responders_Gemfile.erb'))
        run_bundle

        # Add initializers
        bundle_command 'exec rails generate responders:install'

        # Add js and json to respond :html
        replace_in_file 'app/controllers/application_controller.rb',
                        'respond_to :html',
                        'respond_to :html, :js, :json'
        replace_in_file 'app/controllers/application_controller.rb',
                        'require "application_responder"',
                        "require 'application_responder'"

        # Remove comments in locale/responders.yml
        uncomment_lines 'config/locales/responders.en.yml', /alert:/
      end
    end
  end
end
