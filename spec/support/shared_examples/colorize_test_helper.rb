# frozen_string_literal: true

shared_examples 'uses colorize' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match("gem 'colorize'")
    end
  end
end
