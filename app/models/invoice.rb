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

  REASONS = [DUES, WORKSHOP, DONATION, BEVERAGE_FUND, PAYMENT]

  def self.reasons_for_select
    REASONS.map do |reason|
      [reason.titleize, reason]
    end
  end

  def self.paid
    where :paid => true
  end

  def self.unpaid
    where :paid => false
  end

  def self.by_username
    joins(:membership => :user).order('users.username')
  end

  def self.for_user user
    joins(:membership => :user).where(['users.id = ?', user.id])
  end

  def self.for_reason reason
    where 'reason = ?', reason
  end

  def self.total
    group(:reason).select('sum(amount) as amount').first.try(:amount)
  end

  def self.from_date dtime
    where 'due_by > ?', dtime.to_date
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

  def self.latest
    order('due_by DESC').limit(1).first
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
