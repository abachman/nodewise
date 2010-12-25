class Invoice < ActiveRecord::Base
  belongs_to :membership, :include => :user
  has_one :payment, :dependent => :destroy

  has_many :notifications

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :membership_id
  validates_presence_of :due_by

  DUES = "dues"
  WORKSHOP = "workshop"
  DONATION = "donation"
  BEVERAGE_FUND = "beverage fund"
  PAYMENT = "payment"

  def self.reasons_for_select
    [DUES, WORKSHOP, DONATION, BEVERAGE_FUND, PAYMENT].map do |reason|
      [reason.titleize, reason]
    end
  end

  def self.unpaid
    where(['paid IS NULL OR paid = ?', false])
  end

  def self.by_username
    joins(:membership => :user).order('users.username')
  end

  def self.for_user user
    joins(:membership => :user).where(['users.id = ?', user.id])
  end

  def self.send_reminders
    # Mail stuff
    Invoice.unpaid.where("due_by >= ? AND due_by < ?", DateTime.now, DateTime.now + 3.days).joins(:membership => :user).each do |invoice|
      if invoice.membership.user.receive_notifications? && !invoice.reminded?
        UserMailer.dues_reminder(invoice.membership.user).deliver
        Notification.create :invoice_id => invoice.id, :cause => Notification::REMINDER
        puts %[sent email to "#{ invoice.membership.user.full_name }" <#{ invoice.membership.user.email }>]
      end
    end
  end

  def label
    "%s, %s, %s" % [membership.user.full_name, reason, due_by.strftime("%d %b %Y")]
  end

  def overdue?
    DateTime.now > due_by
  end

  def reminded?
    notifications.where(:cause => Notification::REMINDER).count > 0
  end

end
