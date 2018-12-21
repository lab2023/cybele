# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Command line help output' do
  let(:help_text) { cybele_help_command }

  it 'does not contain the default rails usage statement' do
    expect(help_text).not_to include('rails new APP_PATH [options]')
  end

  it 'provides the correct usage statement for cybele' do
    expect(help_text).to include <<~EOH
      Usage:
        cybele APP_PATH [options]
    EOH
  end

  it 'does not contain the default rails group' do
    expect(help_text).not_to include('Rails options:')
  end

  it 'provides help and version usage within the cybele group' do
    expect(help_text).to include <<~EOH
Cybele options:
  -h, [--help], [--no-help]                                  # Show cybele help message and quit
  -v, [--version], [--no-version]                            # Show cybele version number and quit
      [--skip-ask], [--no-skip-ask]                          # Skip ask for cybele options. Default: skip
                                                             # Default: true
      [--skip-create-database], [--no-skip-create-database]  # Skip create database. Default: don't skip
      [--skip-sidekiq], [--no-skip-sidekiq]                  # Skip sidekiq integration. Default: don't skip
      [--skip-simple-form], [--no-skip-simple-form]          # Skip simple_form integration. Default: don't skip
      [--skip-show-for], [--no-skip-show-for]                # Skip show_for integration. Default: don't skip
      [--skip-haml], [--no-skip-haml]                        # Skip haml and haml-rails integration. Default: don't skip
      [--skip-view-files], [--no-skip-view-files]            # Skip view files. Default: don't skip. Dependent: haml, show-for, simple-form
      [--skip-docker], [--no-skip-docker]                    # Skip docker development environment. Default: don't skip
EOH
  end

  it 'does not show the default extended rails help section' do
    expect(help_text).not_to include('Create cybele files for app generator.')
  end

  it 'contains the usage statement from the cybele gem' do
    expect(help_text).to include IO.read(usage_file)
  end
end
