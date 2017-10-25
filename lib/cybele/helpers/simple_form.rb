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
    end
  end
end
