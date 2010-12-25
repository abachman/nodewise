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

  # like "delete"
  def cancel
    @invoice.destroy
  end

  def send_reminder
    @user = @invoice.membership.user
    UserMailer.dues_reminder(@user).deliver
    Notification.create! :invoice_id => @invoice.id, :cause => Notification::REMINDER
    respond_to do |format|
      format.html { 
        flash[:success] = "Successfully sent email to #{ @user.email }"
        redirect_to params[:return_to] || members_path 
      }
      format.js # templated
    end
  end

  def send_overdue
    @user = @invoice.membership.user
    UserMailer.dues_overdue(@user).deliver
    Notification.create! :invoice_id => @invoice.id, :cause => Notification::OVERDUE
    respond_to do |format|
      format.html {
        flash[:success] = "Successfully sent email to #{ @user.email }"
        redirect_to params[:return_to] || members_path
      }
      format.js # templated
    end
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
