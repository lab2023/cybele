# frozen_string_literal: true

module Cybele
  module Helpers
    module Mailer
      def configure_action_mailer
        action_mailer_host 'development'
        action_mailer_host 'staging'
        action_mailer_host 'production'
      end

      def configure_smtp
        configure_environment 'staging',
                              template_content('recipient_interceptor/recipient_interceptor_staging.rb.erb')
        configure_environment 'production', template_content('mailer/smtp.rb.erb')
        configure_environment 'staging', template_content('mailer/smtp.rb.erb')
        append_file 'config/settings.yml', template_content('mailer/mailer_settings.yml.erb')
      end

      def setup_letter_opener
        configure_environment 'development', template_content('mailer/letter_opener.rb.erb')
      end
    end
  end
end
