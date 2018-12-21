# frozen_string_literal: true

shared_examples 'uses bullet' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match("gem 'bullet'")

      locale_file = content('config/environments/development.rb')
      expect(locale_file).to match('Bullet')
    end
  end
end
