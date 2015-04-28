class UserMailer < ApplicationMailer

  def welcome_email(user)
      @user = user
      @user.update_email_confirmation_token
      @url  = "http://#{ENV['FOODSWATCH_URL']}/email_confirmation?token=#{@user.email_confirmation_token}&id=#{@user.id}"
      mail(to: @user.email, subject: '欢迎来到FOODSWATCH')
  end

end
