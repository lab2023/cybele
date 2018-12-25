# frozen_string_literal: true

shared_examples 'uses rollbar' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'rollbar'/)

      config_file = content('config/initializers/rollbar.rb')
      expect(config_file).to match(/^Rollbar.configure/)
    end
  end
end
