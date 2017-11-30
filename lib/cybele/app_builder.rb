# frozen_string_literal: true

module Cybele
  class AppBuilder < Rails::AppBuilder
    include Cybele::Helpers
    include Cybele::Helpers::Staging
    include Cybele::Helpers::Sidekiq
    include Cybele::Helpers::Responders
    include Cybele::Helpers::SimpleForm
    include Cybele::Helpers::Dotenv
    include Cybele::Helpers::RecipientInterceptor
    include Cybele::Helpers::ShowFor
    include Cybele::Helpers::Haml
    include Cybele::Helpers::LocaleLanguage
    include Cybele::Helpers::Mailer
    include Cybele::Helpers::Paperclip
    include Cybele::Helpers::Devise
    include Cybele::Helpers::ErrorPages
    include Cybele::Helpers::ViewFiles::AssetsFiles
    include Cybele::Helpers::ViewFiles::ViewGems
    include Cybele::Helpers::Docker
    include Cybele::Helpers::Pronto
    include Cybele::Helpers::LandingPages

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
      append_file('.env.staging', template_content('ssl/ssl_env_staging.erb'))
      append_file('.env.production', template_content('ssl/ssl_env_production.erb'))
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
    end

    def generate_rollbar
      generate 'rollbar'
    end

    def configure_bullet
      configure_environment 'development', template_content('bullet/bullet_settings.rb.erb')
    end

    def setup_gitignore_files
      remove_file '.gitignore', force: true
      copy_file 'cybele_gitignore', '.gitignore'
    end

    def setup_gitignore_folders
      %w[
        app/assets/images
        db/migrate
        spec/support
        spec/lib
        spec/models
        spec/views
        spec/controllers
        spec/helpers
      ].each do |dir|
        empty_directory_with_keep_file dir
      end
    end

    def git_and_git_flow_commands
      git :init
      git flow: 'init -d -f'
      git add: '.'
      git commit: '-m "Project initialized"'
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
