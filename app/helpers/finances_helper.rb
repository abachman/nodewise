module FinancesHelper
  def invoice_amounts_hash invoices
    Hash[invoices.map {|i| [i.id, number_to_currency(i.amount)]}]
  end
end
