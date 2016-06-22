class AdminMailer < BaseMailer

  def login_info(admin_id, password)
    @admin      = Admin.find admin_id
    @password   = password
    @subject    = t('email.admin.login_info.title')
    mail(to: @admin.email, subject: @subject)
  end

end
