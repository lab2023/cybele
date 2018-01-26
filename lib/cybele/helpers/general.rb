# frozen_string_literal: true

module Cybele
  module Helpers
    module General
      def readme
        template 'README.md.erb',
                 'README.md',
                 force: true
      end

      def remove_readme_rdoc
        remove_file 'README.rdoc',
                    force: true
      end

      def add_gems
        # Add gems
        append_file('Gemfile', template_content('Gemfile.erb'))
      end

      def force_ssl_setting
        gsub_file 'config/environments/production.rb',
                  /# config.force_ssl = true/, "config.force_ssl = ENV['RAILS_FORCE_SSL'].present?"
        gsub_file 'config/environments/staging.rb',
                  /# config.force_ssl = true/, "config.force_ssl = ENV['RAILS_FORCE_SSL'].present?"
        %w[.env.local .env.production .env.staging .env.sample].each do |env|
          append_file(env, template_content('ssl/ssl_env_all.erb'))
        end
      end

      def add_editor_config
        copy_file 'editorconfig', '.editorconfig'
      end

      def add_ruby_version
        copy_file 'ruby-version', '.ruby-version'
      end

      def add_cybele_version
        copy_file 'VERSION.txt', 'VERSION.txt'
        run 'ln -s ../VERSION.txt public/VERSION.txt'
      end

      def use_postgres_config_template
        template 'postgresql_database.yml.erb',
                 'config/database.yml',
                 force: true
      end

      def create_database
        bundle_command 'exec rake db:create db:migrate'
      end

      def generate_config
        generate 'config:install'
        run 'cp config/settings/development.yml config/settings/staging.yml'
        append_file('config/settings.yml', template_content('settings.yml.erb'))
        remove_file 'config/settings.local.yml', force: true
      end

      def generate_rollbar
        generate 'rollbar'
      end

      def generate_guard
        bundle_command 'exec guard init'
        inject_into_file('Guardfile', "\n\n#{template_content('guardfile/guardfile_settings.rb.erb')}",
                         after: 'config/Guardfile" instead of "Guardfile"')
      end

      def configure_bullet
        configure_environment 'development', template_content('bullet/bullet_settings.rb.erb')
      end

      private

      def configure_environment(rails_env, config)
        inject_into_file("config/environments/#{rails_env}.rb", "\n#{config}", before: "\nend")
      end

      def action_mailer_host(rails_env)
        configure_environment(rails_env, template_content('mailer/host.rb.erb'))
      end
    end
  end
end
