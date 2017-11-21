# frozen_string_literal: true

module DotenvTestHelper
  def dotenv_test
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'dotenv-rails'/)

    env_sample_file_test
    env_local_file_test
    env_staging_file_test
    env_production_file_test
  end

  private

  def env_sample_file_test
    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('ROOT_PATH=http://localhost:3000')
  end

  def env_local_file_test
    env_local_file = content('.env.local')
    expect(env_local_file).to match('ROOT_PATH=http://localhost:3000')
  end

  def env_staging_file_test
    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('ROOT_PATH=https://staging-dummy_app.herokuapp.com')
  end

  def env_production_file_test
    env_production_file = content('.env.production')
    expect(env_production_file).to match('ROOT_PATH=https://dummy_app.herokuapp.com')
  end
end
