# frozen_string_literal: true

module Cybele
  module Helpers
    private

    def replace_in_file(relative_path, find, replace)
      path = File.join(destination_root, relative_path)
      contents = IO.read(path)
      unless contents.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end
      File.open(path, 'w') { |file| file.write(contents) }
    end

    def template_content(file)
      File.read(File.expand_path(find_in_source_paths(file)))
    end

    def configure_app_name(files)
      files.each do |file|
        gsub_file file, /<%= app_name %>/, app_name
      end
    end
  end
end
