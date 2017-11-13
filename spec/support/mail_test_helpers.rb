# frozen_string_literal: true

module MailTestHelpers
  def mail_test_helper(path)
    file = content(path)
    expect(file).to match('smtp')
    expect(file).to match('address:')
    expect(file).to match('port:')
    expect(file).to match('enable_starttls_auto:')
    expect(file).to match('user_name:')
    expect(file).to match('password:')
    expect(file).to match('authentication:')
    expect(file).to match('host:') unless content('config/settings.yml').present?
  end
end
