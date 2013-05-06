module Cybele
  class AppBuilder < Rails::AppBuilder

    include Thor::Actions
    include Thor::Shell

    def add_readme_md
      template 'README.md.erb', 'README.md', :force => true
    end

    def remove_public_index
      say 'public'
      remove_file 'public/index.html'
    end

    def remove_readme_rdoc
      say 'readme'
      remove_file 'README.rdoc'
    end

  end
end