module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile_new, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppBuilder < Rails::AppBuilder

    # Internal: Overwrite super class readme
    def readme
      template 'README.md.erb', 'README.md', :force => true
    end

    # Internal: Overwrite superclass gemfile
    def gemfile
      template 'Gemfile_new', 'Gemfile', :force => true
    end

    # Remove: Remove public index file
    def remove_public_index
      remove_file 'public/index.html'
    end

    # Internal: Remove README.rdoc file
    def remove_readme_rdoc
      remove_file 'README.rdoc'
    end

    # Internal: Replace gemfile
    def replace_gemfile
      remove_file 'Gemfile_new'
      copy_file 'Gemfile_new', 'Gemfile_new'
    end

  end
end