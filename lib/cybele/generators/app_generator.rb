require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppGenerator < Rails::Generators::AppGenerator

    # Internal: Default use postgresql
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
                 :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    # Internal: Default skip Test::Unit
    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
                 :desc => 'Skip Test::Unit files'

    # Internal: Finish template
    def finish_template
      invoke :customization
      super
    end

    # Internal: Customization template
    def customization
      invoke :add_readme_md
      invoke :remove_files_we_dont_need
    end

    # Internal: Add Readme.md file
    def add_readme_md
      say 'Add README.md'
      build :readme
    end

    # Internal: Remove files don't need
    def remove_files_we_dont_need
      say 'Remove files we don\'t need'
      build :remove_public_index
      build :remove_readme_rdoc
    end

  end
end