# frozen_string_literal: true

module Cybele
  module Helpers
    module ActiveStorage
      def active_storage_setting
        %w[
          config/environments/production.rb
          config/environments/staging.rb
        ].each do |file|
          gsub_file file,
                    /config.active_storage.service = :local/,
                    'config.active_storage.service = :amazon'
        end

        %w[.env.local .env.production .env.staging .env.sample].each do |env|
          append_file(env, template_content('active_storage/amazon_env_all.erb'))
        end

        inject_into_file 'config/storage.yml',
                         template_content('active_storage/active_storage.yml.erb'),
                         before: '# Use rails credentials:edit to set the AWS secrets'
      end
    end
  end
end
