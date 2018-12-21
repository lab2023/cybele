# frozen_string_literal: true

shared_examples 'uses roo-xls' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'roo-xls'/)
    end
  end
end
