# frozen_string_literal: true

module Cybele
  module Helpers
    module RecipientInterceptor
      def configure_recipient_interceptor

        # Add recipient_interceptor staging settings to staging environment file
        configure_environment 'staging', template_content('recipient_interceptor/recipient_interceptor_staging.rb')

        # Add recipient_interceptor staging settings to staging environment file
        append_file 'config/settings.yml', template_content('recipient_interceptor/recipient_interceptor_settings.yml.erb')

      end
    end
  end
end
