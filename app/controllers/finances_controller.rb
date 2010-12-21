class FinancesController < ApplicationController
  def index
    authorize! :manage, Finance

    @members = User.order :username
    @invoices = Invoice.where(['paid IS NULL OR paid = ?', false])
    @payment = Payment.new
  end

end
