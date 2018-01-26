# frozen_string_literal: true

module PaperclipTestHelper
  def paperclip_test
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match(/^gem 'paperclip'/)
    expect(gemfile_file).to match(/^gem 'aws-sdk'/)

    paperclip_env_file_test
  end

  private

  def paperclip_env_file_test
    paperclip_aws_key_test('.env.sample')
    paperclip_aws_key_test('.env.local',
                           bucket: 'dummy_app-development',
                           url: 'dummy_app-development.s3.amazonaws.com')
    paperclip_aws_key_test('.environments/.env.local',
                           bucket: 'dummy_app-development',
                           url: 'dummy_app-development.s3.amazonaws.com')
    paperclip_aws_key_test('.environments/.env.production',
                           bucket: 'dummy_app',
                           url: 'dummy_app.s3.amazonaws.com')
    paperclip_aws_key_test('.environments/.env.staging',
                           bucket: 'dummy_app-staging',
                           url: 'dummy_app-staging.s3.amazonaws.com')
  end

  def paperclip_aws_key_test(env, bucket: '', url: '')
    expect(File).to exist(file_project_path(env))
    file = content(env)
    expect(file).to match("S3_BUCKET_NAME=#{bucket}")
    expect(file).to match("AWS_RAW_URL=#{url}")
    expect(file).to match('AWS_ACCESS_KEY_ID=')
    expect(file).to match('AWS_SECRET_ACCESS_KEY=')
  end
end
