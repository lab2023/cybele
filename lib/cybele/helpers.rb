# frozen_string_literal: true

module Cybele
  module Helpers
    private

    # Change relative_path file content
    # @param [String] relative_path
    # @param [String] find
    # @param [String] replace
    # Example:
    # replace_in_file 'app/controllers/application_controller.rb',
    #                 'respond_to :html',
    #                 'respond_to :html, :js, :json'
    def replace_in_file(relative_path, find, replace)
      path = File.join(destination_root, relative_path)
      contents = IO.read(path)
      raise "#{find.inspect} not found in #{relative_path}" unless contents.gsub!(find, replace)
      File.open(path, 'w') { |file| file.write(contents) }
    end

    # Read template file content
    # @param [String] template_file
    # Example:
    # template_content('error_pages/error_method.erb')
    def template_content(template_file)
      File.read(File.expand_path(find_in_source_paths(template_file)))
    end

    # Change <%= app_name %> string with app_name
    # @param [Array] files
    # Example:
    # configure_app_name(%w[config/settings.yml])
    def configure_app_name(files)
      files.each do |file|
        gsub_file file, /<%= app_name %>/, app_name
      end
    end

    # Add template content to app_file
    # @param [String] app_file
    # @param [String] template_file
    # Example:
    # append_template_to_file('env.sample', 'basic_authentication/no_basic_authentication.erb')
    def append_template_to_file(app_file, template_file)
      append_file(app_file, template_content(template_file))
    end

    # Add template content to multiple app_files
    # @param [Hash] files
    # { app_file => template_file }
    # Example:
    # append_template_to_files('config/settings.yml' => 'paperclip/paperclip_settings.yml.erb')
    def append_template_to_files(files)
      files.each do |app_file, template_file|
        append_file(app_file, template_content(template_file))
      end
    end

    # Remove app files
    # @param [Array] app_files
    # %w[app_file]
    # Example:
    # remove_files(%w[app/views/welcome/index.html.erb])
    def remove_files(app_files)
      app_files.each do |app_file|
        remove_file app_file, force: true
      end
    end

    # Create app file from templates
    # @param [Hash] files
    # { template_file => app_file }
    # Example:
    # files_to_template('dotenv/env.sample.erb' => 'env.sample')
    def files_to_template(files)
      files.each do |template_file, app_file|
        template template_file, app_file, force: true
      end
    end

    # Copy template file to app directory
    # @param [Hash] files
    # { template_file => app_file }
    # Example:
    # copy_file 'config/locales/tr.yml', 'config/locales/tr.yml'
    def copy_files(files)
      files.each do |template_file, app_file|
        copy_file template_file, app_file
      end
    end

    # Copy directory to app directory
    # @param [Hash] dirs
    # { template_dir => app_dir }
    # Example:
    # dirs_to_directory('app_files/app/views/hq' => 'app/views/hq')
    def dirs_to_directory(dirs)
      dirs.each do |template_dir, app_dir|
        directory template_dir, app_dir
      end
    end
  end
end
