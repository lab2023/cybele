# frozen_string_literal: true

shared_examples 'uses to_xls' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'to_xls'/)
    end
  end
end
