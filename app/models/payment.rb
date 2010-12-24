class Payment < ActiveRecord::Base
  belongs_to :invoice

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :invoice_id

  def pay_invoice!
    invoice.paid = true
    invoice.save
  end
end
