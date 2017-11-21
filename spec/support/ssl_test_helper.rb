# frozen_string_literal: true

module SSLTestHelper
  def force_ssl
    config_staging_file = content('config/environments/staging.rb')
    expect(config_staging_file).to match('config.force_ssl')

    config_production_file = content('config/environments/staging.rb')
    expect(config_production_file).to match('config.force_ssl')
  end
end
