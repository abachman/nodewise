class FinancesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_payments_and_invoices

  def index
    authorize! :manage, Finance

    @members = User.order :username
    @payment = Payment.new
  end
end
