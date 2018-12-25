# frozen_string_literal: true

shared_examples 'uses config' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'config'/)
      expect(File).not_to exist(file_project_path('config/settings.local.yml'))

      config_development_file_test
      config_staging_file_test
      config_production_file_test
      config_test_file_test
    end

    def config_development_file_test
      config_development_file = content('config/environments/development.rb')
      expect(config_development_file).to match(/^Rails.application.configure/)
    end

    def config_staging_file_test
      config_staging_file = content('config/environments/staging.rb')
      expect(config_staging_file).to match(/^Rails.application.configure/)
    end

    def config_production_file_test
      config_production_file = content('config/environments/production.rb')
      expect(config_production_file).to match(/^Rails.application.configure/)
    end

    def config_test_file_test
      config_test_file = content('config/environments/test.rb')
      expect(config_test_file).to match(/^Rails.application.configure/)
    end
  end
end
