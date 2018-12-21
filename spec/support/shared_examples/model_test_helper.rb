# frozen_string_literal: true

shared_examples 'uses model files' do
  context do
    it do
      admin_model = content('app/models/admin.rb')
      expect(admin_model).to match('login_info_mailer')

      audit_model = content('app/models/audit.rb')
      expect(audit_model).to match('class Audit')
    end
  end
end
