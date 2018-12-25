# frozen_string_literal: true

shared_examples 'uses cybele_version' do
  context do
    it do
      expect(File).to exist(file_project_path('VERSION.txt'))
      expect(File).to exist(file_project_path('public/VERSION.txt'))
    end
  end
end
