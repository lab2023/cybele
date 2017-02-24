require 'spec_helper'

RSpec.describe 'Create new project with default configuration' do

  before(:all) do
    remove_project_directory
    run_cybele
    setup_app_dependencies
  end

  it 'uses default Gemfile' do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    readme_file = IO.read("#{project_path}/README.md")
    expect(gemfile_file).to match(
      /^ruby '#{Cybele::RUBY_VERSION}'/,
    )
    expect(gemfile_file).to match(
      /^gem 'autoprefixer-rails'/,
    )
    expect(gemfile_file).to match(
      /^gem 'rails', '#{Cybele::RAILS_VERSION}'/,
    )
    expect(readme_file).to match(
      /^# #{CybeleTestHelpers::APP_NAME.capitalize}/,
    )
  end
end