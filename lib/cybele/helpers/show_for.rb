# frozen_string_literal: true

module Cybele
  module Helpers
    module ShowFor
      def configure_show_for
        # Run the show_for generator
        bundle_command 'exec rails generate show_for:install'
        # Remove show_for english file
        remove_file 'config/locales/show_for.en.yml', force: true
        # Add show_for turkish file
        copy_file 'config/locales/show_for.tr.yml', 'config/locales/show_for.tr.yml'
      end

      def add_show_for_gem
        # Add show_for gem
        append_file('Gemfile', template_content('show_for/show_for_Gemfile.erb'))
      end
    end
  end
end
