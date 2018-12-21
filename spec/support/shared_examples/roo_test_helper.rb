# frozen_string_literal: true

shared_examples 'uses roo' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'roo'/)
    end
  end
end
