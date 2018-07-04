# frozen_string_literal: true

module Cybele
  module Helpers
    module ActiveStorage
      def active_storage_setting
        %w[config/environments/production.rb config/environments/staging.rb
           config/environments/development.rb].each do |file|
          gsub_file file,
                    /config.active_storage.service = :local/,
                    'config.active_storage.service = :amazon'
        end
        handle_active_storage_change_file_content
        %w[.env.local .env.production .env.staging .env.sample].each do |env|
          append_file(env, template_content('active_storage/amazon_env_all.erb'))
        end
      end

      private

      def handle_active_storage_change_file_content
        replace_in_file 'config/storage.yml',
                        'Rails.application.credentials.dig(:aws, :access_key_id)',
                        "ENV['AWS_ACCESS_KEY_ID']"
        replace_in_file 'config/storage.yml',
                        'Rails.application.credentials.dig(:aws, :secret_access_key)',
                        "ENV['AWS_SECRET_ACCESS_KEY']"
        replace_in_file 'config/storage.yml',
                        'us-east-1',
                        "<%= ENV['AWS_REGION'] %>"
        replace_in_file 'config/storage.yml',
                        'your_own_bucket',
                        "<%= ENV['BUCKET_NAME'] %>"
        replace_in_file 'config/storage.yml',
                        '# Use rails credentials:edit to set the AWS secrets (as aws:access_key_id|secret_access_key)',
                        '# AWS S3 access variable'
      end
    end
  end
end
