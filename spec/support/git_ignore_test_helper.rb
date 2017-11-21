# frozen_string_literal: true

module GitIgnoreTestHelper
  def git_ignore_test
    application_controller_file = content('.gitignore')
    expect(application_controller_file).to match('.DS_Store')
    expect(application_controller_file).to match('.secret')
    expect(application_controller_file).to match('.env')
  end
end
