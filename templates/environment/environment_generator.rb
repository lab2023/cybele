class EnvironmentGenerator < Rails::Generators::Base
  desc 'This generetor create .env.local file from .env.sample'

  source_root File.expand_path(Rails.root, __dir__)

  def copy_environment_file
    copy_file ".env.sample", ".environments/.env.local"
  end
end
