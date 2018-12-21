# frozen_string_literal: true

shared_examples 'uses better_errors' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match("gem 'better_errors'")
      expect(gemfile_file).to match("gem 'binding_of_caller'")
    end
  end
end
