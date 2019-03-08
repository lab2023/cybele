# frozen_string_literal: true

module Cybele
  class AppBuilder < Rails::AppBuilder # rubocop:disable Metrics/ClassLength
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
    include Cybele::Helpers::Devise
    include Cybele::Helpers::ErrorPages
    include Cybele::Helpers::Audited
    include Cybele::Helpers::Routes
    include Cybele::Helpers::BasicAuthentication
    include Cybele::Helpers::AppFiles::AssetsFiles
    include Cybele::Helpers::AppFiles::ControllerFiles
    include Cybele::Helpers::AppFiles::ModelFiles
    include Cybele::Helpers::AppFiles::VendorFiles
    include Cybele::Helpers::AppFiles::MailerFiles
    include Cybele::Helpers::AppFiles::HelperFiles
    include Cybele::Helpers::AppFiles::ViewFiles
    include Cybele::Helpers::AppFiles::ViewGems
    include Cybele::Helpers::Docker
    include Cybele::Helpers::Pronto
    include Cybele::Helpers::General
    include Cybele::Helpers::ActiveStorage

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
      run 'mkdir .environments'
      run 'mv .env.local .environments/'
      run 'mv .env.production .environments/'
      run 'mv .env.staging .environments/'
      run 'ln -s .environments/.env.local .env.local'
      run 'cd .environments && git init && git add . && git commit -m "Env initialized" && cd ..'
      git :init
      git flow: 'init -d -f'
      git add: '.'
      git commit: '-m "Project initialized"'
    end

    def add_pronto_to_gemfile
      # Add gems
      append_file('Gemfile', template_content('pronto/pronto_Gemfile.erb'))
      bundle_command 'update'
      bundle_command 'install'
    end

    def add_environment_to_lib
      copy_file 'environment/environment_generator.rb', 'lib/generators/environment/environment_generator.rb'
    end
  end
end
