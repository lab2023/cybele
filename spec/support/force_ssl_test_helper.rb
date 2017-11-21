# frozen_string_literal: true

module ForceSSLTestHelper
  def force_ssl
    ssl_test
    environment_test
  end

  private

  def ssl_test
    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match('config.force_ssl')

    config_production_file = content('config/environments/staging.rb')
    expect(config_production_file).to match('config.force_ssl')
  end

  def environment_test
    env_staging_file = content('.env.staging')
    expect(env_staging_file).to match('RAILS_FORCE_SSL=')

    env_production_file = content('.env.production')
    expect(env_production_file).to match('RAILS_FORCE_SSL=')
  end
end
