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
        configure_environment 'development', template_content('mailer/smtp.rb.erb')
        append_template_to_file 'config/settings.yml', 'mailer/mailer_settings.yml.erb'
        %w[.env.local .env.production .env.staging env.sample].each do |env|
          append_file(env, template_content('mailer/.env.local.erb'))
        end
      end
    end
  end
end
