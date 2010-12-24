class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    # prepopulate form if possible
    @membership = Membership.find_by_id params[:membership_id]
    render 'new', :layout => nil
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      respond_to do |format|
        format.html {
          flash[:success] = "Successfully created invoice."
          authorized_redirect
        }
        format.js {
          render :partial => 'success', :locals => {:show_username => (params[:show_username].to_s == '1')}
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

  # generate new monthly invoices for all active members
  def generate
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
