# frozen_string_literal: true

module Cybele
  module Helpers
    module Haml
      def configure_haml
        # Add initializers
        bundle_command 'exec rails generate haml:application_layout convert'
        remove_file 'app/views/layouts/application.html.erb'
      end

      def add_haml_gems
        # Add Gems
        append_file('Gemfile', template_content('haml/haml_Gemfile.erb'))
      end
    end
  end
end
