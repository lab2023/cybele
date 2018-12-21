# frozen_string_literal: true

shared_examples 'uses rails-i18n' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'rails-i18n'/)
    end
  end
end
