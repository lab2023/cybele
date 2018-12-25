# frozen_string_literal: true

shared_examples 'uses default view files' do
  context do
    it do
      # Mailer files
      hq_admins_view = content('app/views/admin_mailer/login_info.html.haml')
      expect(hq_admins_view).to match('@admin')
    end
  end
end
