# frozen_string_literal: true

require 'bundler/setup'

Bundler.require(:default, :test)

source_path = (Pathname.new(__FILE__).dirname + '../lib/cybele').expand_path
require source_path

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include CybeleTestHelpers
  config.include DotenvTestHelper
  config.include ConfigTestHelper
  config.include DeviseTestHelper
  config.include PaperclipTestHelper
  config.include LocaleLanguageTestHelper
  config.include ResponderTestHelper
  config.include ErrorPagesTestHelper
  config.include GitIgnoreTestHelper
  config.include MailTestHelpers
  config.include SSLTestHelper

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
