# frozen_string_literal: true

shared_examples 'uses ssl_setting' do
  context do
    it do
      %w[staging production].each do |env|
        expect(content("config/environments/#{env}.rb")).to match('config.force_ssl')
      end
      force_ssl_environment_test
    end

    def force_ssl_environment_test
      %w[
        .env.sample
        .environments/.env.local
        .environments/.env.staging
        .environments/.env.production
      ].each do |env|
        expect(File).to exist(file_project_path(env))
        expect(content(env)).to match('RAILS_FORCE_SSL=')
      end
    end
  end
end
