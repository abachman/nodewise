class FinancesController < ApplicationController
  def index
    authorize! :manage, Finance

    @members = User.order :username
    @paid_invoices   = Invoice.where(:paid => true).order(:due_by)
    @unpaid_invoices = Invoice.where(:paid => false).joins({:membership => :user}).order('users.username')
    @invoices_for_select = @unpaid_invoices.map {|i|
      ["%s: %s, %s" % [i.membership.user.username, i.reason, i.due_by.strftime("%d %b %Y")], i.id]
    }
    @payment = Payment.new
  end
end
