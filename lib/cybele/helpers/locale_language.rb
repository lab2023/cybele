# frozen_string_literal: true

module Cybele
  module Helpers
    module LocaleLanguage
      def configure_locale_language
        remove_file 'config/locales/en.yml', force: true
        copy_file 'config/locales/tr.yml', 'config/locales/tr.yml'
        copy_file 'config/locales/email.tr.yml', 'config/locales/email.tr.yml'
        copy_file 'config/locales/models.tr.yml', 'config/locales/models.tr.yml'
        copy_file 'config/locales/view.tr.yml', 'config/locales/view.tr.yml'
      end
    end
  end
end
