class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  ## Payments loading for the invoices partial
  def load_payments_and_invoices_for_user
    if @user.nil?
      @user = current_user
    end
    @invoices = Invoice.for_user(@user).order("due_by, users.username")
    @unpaid_invoices = Invoice.unpaid.for_user(@user).order('due_by, users.username')
    @invoices_for_select = @unpaid_invoices.map {|i|
      [i.label, i.id]
    }
  end

  def load_payments_and_invoices
    @invoices = Invoice.joins(:membership => :user).order("due_by, users.username")
    @unpaid_invoices = Invoice.where(:paid => false).joins(:membership => :user).order('users.username')
    @invoices_for_select = @unpaid_invoices.map {|i|
      [i.label, i.id]
    }
  end
end
