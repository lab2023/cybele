# frozen_string_literal: true

module Cybele
  module Helpers
    module SimpleForm
      def configure_simple_form

        # Run the simple_form generator
        bundle_command 'exec rails generate simple_form:install --bootstrap -force'

        # Remove simple_form english file
        remove_file 'config/locales/simple_form.en.yml', force: true

        # Remove simple_form turkish file
        copy_file 'config/locales/simple_form.tr.yml', 'config/locales/simple_form.tr.yml'
      end

      def add_simple_form_gem
        # Add simple_form gem
        append_file('Gemfile', template_content('simple_form/simple_form_Gemfile.erb'))
      end
    end
  end
end
