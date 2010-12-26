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
    @membership = @user.membership
    @invoices = @membership.invoices.joins(:membership => :user).order("due_by DESC, users.username")
  end

  def load_payments_and_invoices
    @invoices = Invoice.joins(:membership => :user).order("due_by DESC, users.username")
  end
end
