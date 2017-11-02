# frozen_string_literal: true

module Cybele
  module Helpers
    module Devise
      def generate_devise_settings
        generate 'devise:install'
        gsub_file 'config/initializers/filter_parameter_logging.rb', /:password/,
                  ':password, :password_confirmation'
        gsub_file 'config/initializers/devise.rb',
                  /please-change-me-at-config-initializers-devise@example.com/, "no-reply@#{app_name}.com"
        inject_into_file 'config/initializers/devise.rb', after: "# config.mailer = 'Devise::Mailer'\n" do
          template_content('devise/devise_mailer.rb.erb')
        end
      end

      def generate_devise_user
        generate 'devise User name:string surname:string is_active:boolean time_zone:string'
        remove_file 'config/locales/devise.en.yml', force: true
      end

      def generate_devise_views
        generate 'devise:views'
      end
    end
  end
end
