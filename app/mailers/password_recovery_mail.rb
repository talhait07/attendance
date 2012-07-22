class PasswordRecoveryMail < ActionMailer::Base
  default :from => "monsur.it07@gmail.com"

  def recovery_email(email,pass)


    mail(:to => email,:subject => '[gmail.com] - lost password',:body => "your forgotten password is : #{pass}")
  end
end
