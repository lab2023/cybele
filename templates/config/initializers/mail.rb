if Rails.env.production?
  MAIL_SETTING = {
      address:              ENV['MAIL_ADDRESS'],  # example 'smtp.mandrillapp.com'
      port:                 '587',
      enable_starttls_auto: true,
      domain:               ENV['MAIL_DOMAIN'],   # example 'domain.com'
      user_name:            ENV['MAIL_USERNAME'], # example 'email@gmail.com'
      password:             ENV['MAIL_PASSWORD'],
      authentication:       'plain'
  }
end


