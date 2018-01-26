# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def login_info(user_id, password)
    @user = User.find(user_id)
    @password = password
    subject = t('mailer.user.login_info.title')
    mail(to: @user.email, subject: subject)
  end
end
