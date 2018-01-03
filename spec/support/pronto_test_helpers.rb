# frozen_string_literal: true

module ProntoTestHelpers
  def pronto_test
    file_exist_test
    file_content_test
    gitignore_test
  end

  private

  def file_exist_test
    gemfile_file = content('Gemfile')
    pronto_gems.each do |gem|
      expect(gemfile_file).to match(gem)
    end
  end

  def pronto_gems
    [
      "gem 'pronto'",
      "gem 'pronto-brakeman'",
      "gem 'pronto-fasterer'",
      "gem 'pronto-flay'",
      "gem 'pronto-haml'",
      "gem 'pronto-poper'",
      "gem 'pronto-rails_best_practices'",
      "gem 'pronto-reek'",
      "gem 'pronto-rubocop'"
    ]
  end

  def file_content_test # rubocop:disable Metrics/AbcSize
    expect(File).to exist(file_project_path('example.pronto.yml'))
    expect(File).to exist(file_project_path('.pronto.yml'))
    expect(File).to exist(file_project_path('.haml-lint.yml'))
    expect(File).to exist(file_project_path('config.reek'))
    expect(File).to exist(file_project_path('.rubocop.yml'))
    expect(File).to exist(file_project_path('bin/rubo'))
  end

  def gitignore_test
    gemfile_file = content('.gitignore')
    expect(gemfile_file).to match('.pronto.yml')
  end
end
