# frozen_string_literal: true

shared_examples 'uses pronto' do
  context do
    it do
      gemfile_file = content('Gemfile')
      pronto_gems.each do |gem|
        expect(gemfile_file).to match(gem)
      end
      file_exist_test(
          %w[
          example.pronto.yml
          .pronto.yml
          .haml-lint.yml
          .erb-lint.yml
          .rubocop.yml
          bin/rubo
        ]
      )
      pronto_gitignore_test
    end

    def pronto_gems
      [
        "gem 'pronto'",
        "gem 'pronto-brakeman'",
        "gem 'pronto-erb_lint'",
        "gem 'pronto-fasterer'",
        "gem 'pronto-flay'",
        "gem 'pronto-haml'",
        "gem 'pronto-poper'",
        "gem 'pronto-rubocop'"
      ]
    end

    def pronto_gitignore_test
      gemfile_file = content('.gitignore')
      expect(gemfile_file).to match('.pronto.yml')
    end
  end
end
