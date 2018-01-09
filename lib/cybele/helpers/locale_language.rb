# frozen_string_literal: true

module Cybele
  module Helpers
    module LocaleLanguage
      def configure_locale_language
        copy_files(
          'config/locales/tr.yml' => 'config/locales/tr.yml',
          'config/locales/en.yml' => 'config/locales/en.yml',
          'config/locales/mailer.tr.yml' => 'config/locales/mailer.tr.yml',
          'config/locales/models.tr.yml' => 'config/locales/models.tr.yml',
          'config/locales/view.tr.yml' => 'config/locales/view.tr.yml',
          'config/locales/mailer.en.yml' => 'config/locales/mailer.en.yml',
          'config/locales/models.en.yml' => 'config/locales/models.en.yml',
          'config/locales/view.en.yml' => 'config/locales/view.en.yml'
        )
        inject_into_file 'config/application.rb',
                         template_content('config/config_application.rb.erb'),
                         after: 'class Application < Rails::Application'
      end
    end
  end
end
