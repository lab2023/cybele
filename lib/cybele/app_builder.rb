module Cybele #:nodoc:#

  # Public: This allows you to override entire operations, like the creation of the
  # Gemfile, README, or JavaScript files, without needing to know exactly
  # what those operations do so you can create another template action.
  class AppBuilder < Rails::AppBuilder

    # Internal: Add readme.md file
    def add_readme_md
      template 'README.md.erb', 'README.md', :force => true
    end

    # Remove: Remove public index file
    def remove_public_index
      say 'public'
      remove_file 'public/index.html'
    end

    # Internal: remove rdoc.md file
    def remove_readme_rdoc
      say 'readme'
      remove_file 'README.rdoc'
    end

  end
end