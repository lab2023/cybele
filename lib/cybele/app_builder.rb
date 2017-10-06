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

    def generate_config
      generate 'config:install'
      run 'cp config/settings/development.yml config/settings/staging.yml'
    end

    def fill_settings_yml
      config = <<-YML
email:
  sandbox: sandbox@#{app_name}.com
  noreply: no-reply@#{app_name}.com
  admin: admin@#{app_name}.com

basic_auth:
  username: #{app_name}
  password: #{app_name}

sidekiq:
  username: #{app_name}
  password: #{app_name}

root_path: <%= ENV['ROOT_PATH'] %>

smtp:
  address: <%= ENV['SMTP_ADDRESS'] %>
  port: 587
  enable_starttls_auto: true
  user_name: <%= ENV['SMTP_USER_NAME'] %>
  password: <%= ENV['SMTP_PASSWORD'] %>
  authentication: 'plain'

AWS:
  S3:
    bucket: <%= ENV['S3_BUCKET_NAME'] %>
    access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
    secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
    aws_url: http://<%= ENV['AWS_RAW_URL'] %>
    aws_raw_url: <%= ENV['AWS_RAW_URL'] %>
    # Bucket region should be ireland for this setting
    end_point: s3-eu-west-1.amazonaws.com
      YML
      prepend_file 'config/settings.yml', config
    end

    private

    def configure_environment(rails_env, config)
      inject_into_file("config/environments/#{rails_env}.rb", "\n#{config}", before: "\nend")
    end
  end
end
