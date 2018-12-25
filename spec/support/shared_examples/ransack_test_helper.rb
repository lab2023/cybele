# frozen_string_literal: true

shared_examples 'uses ransack' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'ransack'/)
    end
  end
end
