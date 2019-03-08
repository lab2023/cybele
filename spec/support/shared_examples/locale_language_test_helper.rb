# frozen_string_literal: true

shared_examples 'uses locale_language' do
  context do
    it do
      expect(File).to exist(file_project_path('config/locales/en.yml'))

      file_content_control_test
      english_file_test
      turkish_file_test
    end

    def file_content_control_test
      locale_file = content('config/locales/tr.yml')
      expect(locale_file).to match('date:')
      expect(locale_file).to match('time:')
      expect(locale_file).to match('number:')
    end

    def english_file_test
      locale_file = content('config/locales/mailer.en.yml')
      expect(locale_file).to match('mailer:')

      locale_file = content('config/locales/models.en.yml')
      expect(locale_file).to match('activerecord:')

      locale_file = content('config/locales/view.en.yml')
      expect(locale_file).to match('view:')
    end

    def turkish_file_test
      locale_file = content('config/locales/mailer.tr.yml')
      expect(locale_file).to match('mailer:')

      locale_file = content('config/locales/models.tr.yml')
      expect(locale_file).to match('activerecord:')

      locale_file = content('config/locales/view.tr.yml')
      expect(locale_file).to match('view:')
    end
  end
end
