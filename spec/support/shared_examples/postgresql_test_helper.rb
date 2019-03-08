# frozen_string_literal: true

shared_examples 'uses postgresql database' do
  context do
    it do
      database_file = content('config/database.yml')
      expect(database_file).to match(/^connection: &connection/)
      expect(database_file).to match(/^  database: #{app_name}_staging/)
    end
  end
end
