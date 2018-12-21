# frozen_string_literal: true

shared_examples 'uses mailer files' do
  context do
    it do
      admin_mailer = content('app/mailers/admin_mailer.rb')
      expect(admin_mailer).to match('class AdminMailer')

      application_mailer = content('app/mailers/application_mailer.rb')
      expect(application_mailer).to match('Settings.email.noreply')
    end
  end
end
