# frozen_string_literal: true

module CybeleTestHelpers
  APP_NAME = 'dummy_app'

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def run_cybele(arguments = nil)
    arguments = "--path=#{root_path} #{arguments}"
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        `
        export DISABLE_SPRING=1;
        #{cybele_bin} #{APP_NAME} #{arguments}
        `
      end
    end
  end

  def content(file_path)
    IO.read(file_project_path(file_path))
  end

  def file_project_path(file_path)
    "#{project_path}/#{file_path}"
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  def app_name
    APP_NAME
  end

  def cybele_help_command
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        `
        #{cybele_bin} -h
        `
      end
    end
  end

  def cybele_help_run(command: 'ls')
    Dir.chdir("#{tmp_path}/#{app_name}") do
      Bundler.with_clean_env do
        `
        #{command}
        `
      end
    end
  end

  def setup_app_dependencies
    return unless File.exist?(project_path)
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        `bundle check || bundle install`
      end
    end
  end

  def drop_dummy_database
    return unless File.exist?(project_path)
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        `rake db:drop`
      end
    end
  end

  def usage_file
    @usage_path ||= File.join(root_path, 'USAGE')
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def cybele_bin
    File.join(root_path, 'bin', 'cybele')
  end

  def root_path
    File.expand_path('../../../', __FILE__)
  end
end
