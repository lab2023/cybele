# frozen_string_literal: true

shared_examples 'uses gitignore' do
  context do
    it do
      application_controller_file = content('.gitignore')
      expect(application_controller_file).to match('.DS_Store')
      expect(application_controller_file).to match('.secret')
      expect(application_controller_file).to match('.env')
    end
  end
end
