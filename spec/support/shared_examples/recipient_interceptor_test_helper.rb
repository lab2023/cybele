# frozen_string_literal: true

shared_examples 'uses recipient_interceptor' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'recipient_interceptor'/)

      config_staging_file = content('config/environments/staging.rb')
      expect(config_staging_file).to match('RecipientInterceptor.new')
    end
  end
end
