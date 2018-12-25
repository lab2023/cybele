# frozen_string_literal: true

shared_examples 'uses write_xlsx' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'write_xlsx'/)
    end
  end
end
