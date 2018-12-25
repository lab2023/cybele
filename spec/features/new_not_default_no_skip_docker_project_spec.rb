# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration and no-skip docker' do
  before(:all) do
    remove_project_directory
    run_cybele(cybele_not_default_parameters(no_skips: %w[docker]))
    setup_app_dependencies
  end

  it_behaves_like 'uses docker development environment without sidekiq'

  it 'match readme' do
    gemfile_file = content('README.md')
    expect(gemfile_file).to match(file_content('README_ONLY_NO_SKIP_DOCKER.md'))
  end
end
