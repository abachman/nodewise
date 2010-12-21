class Invoice < ActiveRecord::Base
  belongs_to :membership, :include => :user
  has_one :payment

  DUES = "dues"
  WORKSHOP = "workshop"
  DONATION = "donation"
  BEVERAGE_FUND = "beverage fund"

  def self.reasons_for_select
    [DUES, WORKSHOP, DONATION, BEVERAGE_FUND].map do |reason|
      [reason.titleize, reason]
    end
  end

  def self.unpaid
    where(['paid IS NULL OR paid = ?', false])
  end

  def self.by_username
    joins({:membership => :user}).order('users.username')
  end
end
