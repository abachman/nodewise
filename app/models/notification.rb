class Notification < ActiveRecord::Base
  belongs_to :invoice, :include => {:membership => :user}

  REMINDER = "reminder"
  OVERDUE  = "overdue"

  def user
    invoice.membership.user
  end
end
