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

      def generate_devise_models
        generate 'devise User name:string surname:string is_active:boolean time_zone:string'
        generate 'devise Admin name:string surname:string is_active:boolean time_zone:string'
        configure_devise_locale_files
        devise_seeds
        configure_app_name(%w[db/seeds.rb])
        add_default_value_to_migrations
      end

      def generate_devise_views
        directory 'devise/devise_views', 'app/views/devise'
      end

      def add_devise_authenticate_admin
        inject_into_file 'app/controllers/hq/application_controller.rb',
                         template_content('devise/devise_authenticate_admin.rb.erb'),
                         after: 'class Hq::ApplicationController < ApplicationController'
      end

      def add_devise_protect_from_forgery
        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('devise/devise_protect_from_forgery.rb.erb'),
                         after: 'respond_to :html, :js, :json'
      end

      def add_devise_strong_parameter
        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('devise/devise_strong_parameter.rb.erb'),
                         after: 'protect_from_forgery with: :exception, prepend: true'

        inject_into_file 'app/controllers/application_controller.rb',
                         template_content('devise/devise_before_action_strong_parameter.rb.erb'),
                         after: 'class ApplicationController < ActionController::Base'
      end

      private

      def configure_devise_locale_files
        remove_file 'config/locales/devise.en.yml', force: true
        copy_file 'config/locales/devise.en.yml', 'config/locales/devise.en.yml'
        copy_file 'config/locales/devise.tr.yml', 'config/locales/devise.tr.yml'
      end

      def devise_seeds
        inject_into_file 'db/seeds.rb', after: "#   Character.create(name: 'Luke', movie: movies.first)\n" do
          template_content('devise/seeds.rb.erb')
        end
      end

      def add_default_value_to_migrations
        Dir.glob('db/migrate/*devise_create*.rb') do |file|
          replace_in_file file, 't.boolean :is_active', 't.boolean :is_active, default: true'
          uncomment_lines file, /t.integer  :sign_in_count, default: 0, null: false/
          uncomment_lines file, /t.datetime :current_sign_in_at/
          uncomment_lines file, /t.datetime :last_sign_in_at/
          uncomment_lines file, /t.inet     :current_sign_in_ip/
          uncomment_lines file, /t.inet     :last_sign_in_ip/
        end
      end
    end
  end
end
