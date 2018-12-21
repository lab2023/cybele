# frozen_string_literal: true

shared_examples 'uses responders' do
  context do
    it do
      gemfile_file = content('Gemfile')
      expect(gemfile_file).to match(/^gem 'responders'/)

      lib_file = content('lib/application_responder.rb')
      expect(lib_file).to match(/^class ApplicationResponder/)

      controller_file_test
      i18n_file_test
    end

    def controller_file_test
      controller_file = content('app/controllers/application_controller.rb')
      expect(controller_file).to match("^require 'application_responder'")
      expect(controller_file).to match('# self.responder = ApplicationResponder')
      expect(controller_file).to match('respond_to :html, :js, :json')
    end

    def i18n_file_test # rubocop:disable Metrics/AbcSize
      expect(File).to exist(file_project_path('config/locales/responders.en.yml'))
      locale_file = content('config/locales/responders.tr.yml')
      expect(locale_file).not_to match('# alert:')
      expect(locale_file).to match('create:')
      expect(locale_file).to match('update:')
      expect(locale_file).to match('destroy:')
    end
  end
end
