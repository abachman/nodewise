require 'date'

class Membership < ActiveRecord::Base
  include ActiveRecord::Transitions

  # Day of the month that payments are due
  PAYMENT_DUE_ON = 20

  # Default monthly fee
  DEFAULT_MONTHLY_FEE = 50

  attr_protected :user_id

  belongs_to :user
  validates_uniqueness_of :user_id

  validates_numericality_of :monthly_fee

  has_many :invoices

  state_machine do
    # a :preactive member can update their profile but cannot pay, participate
    # in voting, or access the space. This is the default state.
    state :preactive

    # an :active member is a full participant in the space
    state :active

    # a :suspended member can pay but not participate
    state :suspended

    # an :inactive member has closed their account and ended their membership.
    state :inactive

    event :activate do
      transitions :to => :active, :from => [:preactive, :suspended, :inactive], :on_transition => :do_activation
    end

    event :deactivate do
      transitions :to => :inactive, :from => [:active, :preactive]
    end

    event :suspend do
      transitions :to => :suspended, :from => [:active]
    end
  end

  def do_activation
    # prepare alerts
    # schedule payment
    self.member_since = DateTime.now.to_date
  end

  def self.active
    where :state => 'active'
  end

  def self.preactive
    joins(:user).order('users.username').where :state => 'preactive'
  end

  def self.next_payment_date after_date=nil
    after_date ||= DateTime.now
    after_date = after_date + 1.month if after_date.day > PAYMENT_DUE_ON

    DateTime.new after_date.year, after_date.month, PAYMENT_DUE_ON
  end

  def self.users_for_select
    joins(:user).order('users.full_name').map do |m|
      [m.user.full_name, m.id]
    end
  end

  def generate_dues_invoice!
    invoice = Invoice.new(
      :membership => self,
      :amount => self.monthly_fee,
      :reason => Invoice::DUES,
      :due_by => Membership.next_payment_date
    )
    unless invoice.save
      puts "UNABLE TO CREATE INVOICE: #{ invoice.errors.full_messages.join(", ") }"
    end

  end

  def self.generate_dues_invoices
    Membership.active.each do |membership|
      # if no next invoice?
      if membership.invoices.for_reason(Invoice::DUES).where(:due_by => self.next_payment_date).count == 0
        puts "Generating dues invoice for #{membership.user.username}"
        membership.generate_dues_invoice!
      end
    end
  end
end
