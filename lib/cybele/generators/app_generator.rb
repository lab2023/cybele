require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
                 :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
                 :desc => 'Skip Test::Unit files'

    def finish_template
      invoke :customization
      super
    end

    def customization
      invoke :add_readme_md
      invoke :remove_files_we_dont_need
    end

    def add_readme_md
      say 'Add README.md'
      build :readme
    end

    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_public_index
      build :remove_readme_rdoc
    end

    protected

    def get_builder_class
      Cybele::AppBuilder
    end

  end
end