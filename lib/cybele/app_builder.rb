module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # cybele_Gemfile, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppBuilder < Rails::AppBuilder

    # Internal: Overwrite super class readme
    def readme
      template 'README.md.erb', 'README.md', :force => true
    end

    # Remove: Remove public index file
    def remove_public_index
      remove_file 'public/index.html'
    end

    # Internal: Remove README.rdoc file
    def remove_readme_rdoc
      remove_file 'README.rdoc'
    end

    # Internal: Remove rails.png file
    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    # Internal: Replace gemfile
    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'cybele_Gemfile', 'Gemfile'
    end

    # Internal: Replace erb files with html files
    def replace_erb_with_haml
      remove_file 'app/views/layouts/application.html.erb'
      template 'app/views/layouts/application.html.haml.erb', 'app/views/layouts/application.html.haml', :force => true
    end

    # Internal: Replace responders controller template
    def install_responder_gem
      copy_file 'lib/application_responder.rb', 'lib/application_responder.rb'
      remove_file 'app/controllers/application_controller.rb'
      copy_file 'app/controllers/application_controller.rb', 'app/controllers/application_controller.rb'
      copy_file 'lib/templates/rails/responders_controller/controller.rb', 'lib/templates/rails/responders_controller/controller.rb'
      copy_file 'config/locales/responders.en.yml', 'config/locales/responders.en.yml'
      copy_file 'config/locales/responders.tr.yml', 'config/locales/responders.tr.yml'
    end

    # Internal: Setup database config
    def replace_database_yml
      template 'config/database.yml.erb', 'config/database.yml', :force => true
    end

    # Internal: Create database
    def create_database
      bundle_command 'exec rake db:create'
    end

    # Internal: Setup gitignore files
    def setup_gitignore_files
      remove_file '.gitignore'
      copy_file 'cybele_gitignore', '.gitignore'
    end

    # Internal: Setup gitignore folders
    def setup_gitignore_folders
      %w(
        app/assets/images
        db/migrate
        spec/support
        spec/lib
        spec/models
        spec/views
        spec/controllers
        spec/helpers
      ).each do |dir|
        empty_directory_with_keep_file dir
      end
    end

    # Internal: Setup asset precompile
    # Look for information https://github.com/thomas-mcdonald/bootstrap-sass#rails-4
    def setup_asset_precompile

      config = <<-RUBY


    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.sass.preferred_syntax = :sass
      RUBY

      inject_into_file 'config/application.rb', config, :after => '# config.i18n.default_locale = :de'
    end

    def setup_application_js
      config = <<-RUBY

//= require bootstrap
      RUBY

      inject_into_file 'app/assets/javascripts/application.js', config, :after => '//= require turbolinks'

    end

    # Internal: Leftovers
    def leftovers
    end
  end
end