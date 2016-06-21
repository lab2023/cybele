class AdminMailer < BaseMailer

  def send_login_information(admin_id, password)
    @admin      = Admin.find admin_id
    @password   = password
    @subject    = t('email.admin.send_login_information.title')
    mail(to: @admin.email, subject: @subject)
  end

end
