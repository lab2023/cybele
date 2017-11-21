# frozen_string_literal: true

module PaperclipTestHelper
  def paperclip_test
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem "paperclip"/)
    expect(gemfile_file).to match(/^gem 'aws-sdk'/)

    env_sample_file_test
    env_local_file_test
    env_staging_file_test
    env_production_file_test
  end

  private

  def env_sample_file_test
    env_sample_file = content('env.sample')
    expect(env_sample_file).to match('S3_BUCKET_NAME=')
    expect(env_sample_file).to match('AWS_RAW_URL=')
    expect(env_sample_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_sample_file).to match('AWS_SECRET_ACCESS_KEY=')
  end

  def env_local_file_test
    env_local_file = content('.env.local')
    expect(env_local_file).to match('S3_BUCKET_NAME=dummy_app-development')
    expect(env_local_file).to match('AWS_RAW_URL=dummy_app-development.s3.amazonaws.com')
    expect(env_local_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_local_file).to match('AWS_SECRET_ACCESS_KEY=')
  end

  def env_staging_file_test
    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('S3_BUCKET_NAME=dummy_app-staging')
    expect(env_staging_file).to match('AWS_RAW_URL=dummy_app-staging.s3.amazonaws.com')
    expect(env_staging_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_staging_file).to match('AWS_SECRET_ACCESS_KEY=')
  end

  def env_production_file_test
    env_production_file = content('.env.production')
    expect(env_production_file).to match('S3_BUCKET_NAME=dummy_app')
    expect(env_production_file).to match('AWS_RAW_URL=dummy_app.s3.amazonaws.com')
    expect(env_production_file).to match('AWS_ACCESS_KEY_ID=')
    expect(env_production_file).to match('AWS_SECRET_ACCESS_KEY=')
  end
end
