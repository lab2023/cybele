require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele
  
  class AppGenerator < Rails::Generators::AppGenerator

    def customize_gemfile
      build :replace_gemfile
      bundle_command 'install --binstubs=bin/stubs'
    end

    def setup_editor_config
      say 'Add .editor_config file'
      build :add_editor_config
    end

    def setup_ruby_version
      say 'Add .ruby-version file'
      build :add_ruby_version
    end

    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_readme_rdoc
    end

    def goodbye
      say 'Congratulations! That\'s all...'
    end

    protected

    def get_builder_class
      Cybele::AppBuilder
    end
  end
end