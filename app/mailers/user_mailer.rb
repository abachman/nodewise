class UserMailer < ActionMailer::Base
  default :from => "membership@baltimorenode.org"

  # en.user_mailer.dues_reminder.subject
  def dues_reminder(user)
    @greeting = "Hi"
    @user = user

    mail :to => user.email
  end

  # en.user_mailer.dues_overdue.subject
  def dues_overdue(user)
    @greeting = "Hi"
    @user = user
    mail :to => user.email
  end

  def user_created(user)
    @user = user
    mail :to => User.having_role(:admin).map(&:email)
  end
end
