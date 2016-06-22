class BaseMailer < ActionMailer::Base
  default from: Settings.email.noreply
  layout 'mailer'
end