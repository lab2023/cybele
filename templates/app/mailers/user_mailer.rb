class UserMailer < BaseMailer

  def send_login_information(user_id, password)
    @user      = User.find user_id
    @password   = password
    @subject    = t('email.user.send_login_information.title')
    mail(to: @user.email, subject: @subject)
  end

end
