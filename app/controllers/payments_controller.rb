class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def create
    @payment = Payment.new(params[:payment])
    if @payment.save
      if params[:fully_paid].to_i == 1
        @payment.pay_invoice!
      end
      respond_to do |format|
        format.html {
          flash[:success] = "Successfully created payment."
          authorized_redirect
        }
        format.js {
          render :partial => 'success'
        }
      end
    else
      respond_to do |format|
        format.html {
          render 'new'
        }
        format.js {
          render :partial => 'error'
        }
      end
    end
  end

  def new
    @invoice = Invoice.find_by_id params[:invoice_id]
    if @invoice.nil?
      flash[:error] = "You must provide a valid invoice id."
      authorized_redirect
      return
    elsif @invoice.paid?
      flash[:error] = "That invoice is already paid."
      authorized_redirect
      return
    end
    authorize! :read, @invoice
    render 'new', :layout => nil
  end

protected
  def authorized_redirect
    if can? :manage, Invoice
      redirect_to finances_path
    else
      redirect_to '/'
    end
  end
end
