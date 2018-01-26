# frozen_string_literal: true

module Cybele
  module Helpers
    module Responders
      def configure_responders
        # Add gems
        append_file('Gemfile', template_content('responders/responders_Gemfile.erb'))
        run_bundle

        # Add initializers
        bundle_command 'exec rails generate responders:install'

        replace_responders_file_contents
      end

      private

      def replace_responders_file_contents
        # Add js and json to respond :html
        replace_in_file 'app/controllers/application_controller.rb',
                        'respond_to :html',
                        'respond_to :html, :js, :json'
        comment_lines 'app/controllers/application_controller.rb',
                      /self.responder = ApplicationResponder/
        replace_in_file 'app/controllers/application_controller.rb',
                        'require "application_responder"',
                        "require 'application_responder'"
        # Remove comments in locale/responders.yml
        remove_file 'config/locales/responders.en.yml', force: true
        copy_file 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
        copy_file 'config/locales/responders.en.yml', 'config/locales/responders.en.yml'
      end
    end
  end
end
