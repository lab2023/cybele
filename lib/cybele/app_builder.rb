# frozen_string_literal: true

module Cybele
  class AppBuilder < Rails::AppBuilder
    include Cybele::Helpers
    include Cybele::Helpers::Sidekiq
    include Cybele::Helpers::Responders

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
      append_file('Gemfile', template_content('cybele_Gemfile.erb'))
    end

    def add_editor_config
      copy_file 'editorconfig', '.editorconfig'
    end

    def add_ruby_version
      copy_file 'ruby-version', '.ruby-version'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb',
               'config/database.yml',
               force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def configure_recipient_interceptor
      config = <<-RUBY
  Mail.register_interceptor RecipientInterceptor.new(Settings.email.sandbox, subject_prefix: '[STAGING]')
      RUBY
      configure_environment 'staging', config
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'
    end

    private

    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb", "\n#{config}", before: "\nend")
    end
  end
end
