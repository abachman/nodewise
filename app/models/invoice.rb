class Invoice < ActiveRecord::Base
  belongs_to :membership
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
end
