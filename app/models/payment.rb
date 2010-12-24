class Payment < ActiveRecord::Base
  belongs_to :invoice

  def pay_invoice!
    invoice.paid = true
    invoice.save
  end
end
