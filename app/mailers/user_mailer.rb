class UserMailer < ActionMailer::Base
  default :from => "membership@baltimorenode.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.payment_reminder.subject
  #
  def dues_reminder(user)
    @greeting = "Hi"
    @user = user

    mail :to => user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.payment_overdue.subject
  #
  def dues_overdue(user)
    @greeting = "Hi"
    @user = user
    mail :to => user.email
  end
end
