require 'spec_helper'

RSpec.describe 'Create new project with default configuration' do

  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_cybele
    setup_app_dependencies
  end

  it 'uses default Gemfile' do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    readme_file = IO.read("#{project_path}/README.md")
    expect(gemfile_file).to match(
      /^gem 'rails', '#{Cybele::RAILS_VERSION}'/,
    )
    expect(readme_file).to match(
      /^# #{CybeleTestHelpers::APP_NAME.capitalize}/,
    )
  end

  it 'uses postgresql database template' do
    database_file = IO.read("#{project_path}/config/database.yml")
    expect(database_file).to match(/connection: &connection/)
    expect(database_file).to match(/  database: #{CybeleTestHelpers::APP_NAME}_staging/)
  end

end