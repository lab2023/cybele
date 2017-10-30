# frozen_string_literal: true

module Cybele
  module Helpers
    module LocaleLanguage
      def configure_locale_language
        copy_file 'config/locales/tr.yml', 'config/locales/tr.yml'
        copy_file 'config/locales/email.tr.yml', 'config/locales/email.tr.yml'
        copy_file 'config/locales/models.tr.yml', 'config/locales/models.tr.yml'
        copy_file 'config/locales/view.tr.yml', 'config/locales/view.tr.yml'
        copy_file 'config/locales/email.en.yml', 'config/locales/email.en.yml'
        copy_file 'config/locales/models.en.yml', 'config/locales/models.en.yml'
        copy_file 'config/locales/view.en.yml', 'config/locales/view.en.yml'
      end
    end
  end
end
