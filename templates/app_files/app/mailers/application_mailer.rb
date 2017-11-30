# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Settings.email.noreply
  layout 'mailer'
end
