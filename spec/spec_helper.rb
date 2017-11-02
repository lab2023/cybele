# frozen_string_literal: true

require 'bundler/setup'

Bundler.require(:default, :test)

source_path = (Pathname.new(__FILE__).dirname + '../lib/cybele').expand_path
require source_path

Dir['./spec/support/**/*.rb'].each { |file| require file }

def mail_test_helper(path)
  file = content(path)
  expect(file).to match('smtp')
  expect(file).to match('address:')
  expect(file).to match('port:')
  expect(file).to match('enable_starttls_auto:')
  expect(file).to match('user_name:')
  expect(file).to match('password:')
  expect(file).to match('authentication:')
  unless content('config/settings.yml').present?
    expect(file).to match('host:')
  end
end

RSpec.configure do |config|
  config.include CybeleTestHelpers

  config.before(:all) do
    create_tmp_directory
  end

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation
end
