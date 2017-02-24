module Cybele

  class AppBuilder < Rails::AppBuilder

    def readme
      template 'README.md.erb', 'README.md', force: true
    end

    def replace_gemfile
      remove_file 'Gemfile', force: true
      copy_file 'cybele_Gemfile', 'Gemfile'
    end

    def remove_readme_rdoc
      remove_file 'README.rdoc', force: true
    end

    def add_editor_config
      copy_file 'editorconfig', '.editorconfig'
    end

    def add_ruby_version
      copy_file 'ruby-version', '.ruby-version'
    end

  end
end
