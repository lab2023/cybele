# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def login_info(admin_id, password)
    @admin = Admin.find admin_id
    @password = password
    subject = t('mailer.admin.login_info.title')
    mail(to: @admin.email, subject: subject)
  end
end
