# frozen_string_literal: true

module ProntoTestHelpers
  def pronto_test
    gemfile_file = content('Gemfile')
    expect(gemfile_file).to match("gem 'pronto'")
    expect(gemfile_file).to match("gem 'pronto-flay'")
    expect(gemfile_file).to match("gem 'pronto-rubocop'")

    expect(File).to exist(file_project_path('example.pronto.yml'))
    expect(File).to exist(file_project_path('.pronto.yml'))
    expect(File).to exist(file_project_path('.rubocop.yml'))
    expect(File).to exist(file_project_path('bin/rubo'))

    gemfile_file = content('.gitignore')
    expect(gemfile_file).to match('.pronto.yml')
  end
end
