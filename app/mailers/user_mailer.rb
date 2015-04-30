class UserMailer < ApplicationMailer

  def welcome_email(user)
      @user = user
      @url  = "http://#{ENV['FOODSWATCH_URL']}/email_confirmation?token=#{@user.email_confirmation_token}&id=#{@user.id}"
      mail(to: @user.email, subject: '欢迎来到 FOODSWATCH')
  end

  def change_password_email(user)
    @user = user
    @url = "http://#{ENV['FOODSWATCH_URL']}/passwords/#{@user.change_password_token}?email=#{@user.email}"
    mail(to: @user.email, subject: '请及时修改您在 FOODSWATCH 的密码')
  end
end
