# frozen_string_literal: true

module ProntoTestHelpers
  def pronto_test
    gemfile_file = content('Gemfile')
    pronto_gems.each do |gem|
      expect(gemfile_file).to match(gem)
    end
    file_exist_test(
        %w[
        example.pronto.yml
        .pronto.yml
        .haml-lint.yml
        config.reek
        .rubocop.yml
        bin/rubo
      ]
    )
    pronto_gitignore_test
  end

  private

  def pronto_gems
    [
      "gem 'pronto'",
      "gem 'pronto-brakeman'",
      "gem 'pronto-fasterer'",
      "gem 'pronto-flay'",
      "gem 'pronto-haml'",
      "gem 'pronto-poper'",
      "gem 'pronto-reek'",
      "gem 'pronto-rubocop'"
    ]
  end

  def pronto_gitignore_test
    gemfile_file = content('.gitignore')
    expect(gemfile_file).to match('.pronto.yml')
  end
end
