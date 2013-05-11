module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile_new, README, or JavaScript files, without needing to know exactly
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
      copy_file 'Gemfile_new', 'Gemfile'
    end

    # Internal: Replace erb files with html files
    def replace_erb_with_haml
      remove_file 'app/views/layouts/application.html.erb'
      template 'app/views/layouts/application.html.haml.erb', 'app/views/layouts/application.html.haml', :force => true
    end
  end
end