# frozen_string_literal: true

module ForceSSLTestHelper
  def force_ssl_test
    %w[staging production].each do |env|
      expect(content("config/environments/#{env}.rb")).to match('config.force_ssl')
    end
    force_ssl_environment_test
  end

  private

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
