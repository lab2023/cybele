# frozen_string_literal: true

module Cybele
  module Helpers
    module HamlAndHamlRails
      def configure_haml_and_haml_rails
        # Add initializers
        bundle_command 'exec rails generate haml:application_layout convert'
        remove_file 'app/views/layouts/application.html.erb'
      end

      def add_haml_and_haml_rails_gems
        # Add Gems
        append_file('Gemfile', template_content('haml_and_haml_rails/haml_Gemfile.erb'))
      end
    end
  end
end
