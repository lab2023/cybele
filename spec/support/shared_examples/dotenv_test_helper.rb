# frozen_string_literal: true

shared_examples 'has .env files' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'dotenv-rails'/)

      env_file_test
      env_staging_file_test
      env_production_file_test
    end

    def env_file_test
      %w[.env.sample .env.local .environments/.env.local].each do |env|
        expect(File).to exist(file_project_path(env))
        expect(content(env)).to match('ROOT_PATH=http://localhost:3000')
      end
    end

    def env_staging_file_test
      env_staging_file = content('.environments/.env.staging')
      expect(env_staging_file).to match('ROOT_PATH=https://staging-dummy_app.herokuapp.com')
    end

    def env_production_file_test
      env_production_file = content('.environments/.env.production')
      expect(env_production_file).to match('ROOT_PATH=https://dummy_app.herokuapp.com')
    end
  end
end
