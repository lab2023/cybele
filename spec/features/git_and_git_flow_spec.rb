# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create new project without default configuration' do
  before do
    drop_dummy_database
    remove_project_directory
    run_cybele('--database=sqlite3 --skip-create-database --skip-sidekiq --skip-simple-form --skip-show-for'\
               ' --skip-haml')
    setup_app_dependencies
  end

  let(:git_branch) { cybele_help_run(command: 'git branch') }

  it 'git branch test' do
    expect(git_branch).to include <<~EOH
      * develop
        master
    EOH
  end

  it 'git flow test' do
    cybele_help_run(command: 'git flow feature start test')
    git_flow = cybele_help_run(command: 'git branch')
    expect(git_flow).to include <<~EOH
        develop
      * feature/test
        master
    EOH
  end
end
