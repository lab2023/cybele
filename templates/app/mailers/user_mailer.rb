class UserMailer < BaseMailer

  def login_info(user_id, password)
    @user      = User.find user_id
    @password   = password
    @subject    = t('email.user.login_info.title')
    mail(to: @user.email, subject: @subject)
  end

end
