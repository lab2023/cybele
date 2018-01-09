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
        %w[production staging development].each do |env|
          configure_environment env, template_content('mailer/smtp.rb.erb')
        end
        append_template_to_file 'config/settings.yml', 'mailer/mailer_settings.yml.erb'
        %w[.env.local .env.production .env.staging env.sample].each do |env|
          append_template_to_file(env, 'mailer/.env.local.erb')
        end
      end
    end
  end
end
