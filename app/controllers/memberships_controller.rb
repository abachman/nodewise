class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    @user = @membership.user
    load_payments_and_invoices_for_user
  end

  def update
    if cannot? :change_fee, @membership
      params.delete(:change_fee)
    end

    if @membership.update_attributes(params[:membership]) 
      flash[:notice] = "Successfully updated membership for #{ @membership.user.username }."
      redirect_to member_path(@membership.user.username)
    else
      render :action => 'edit'
    end
  end

  # this is how a person becomes a member! they grow up so fast...
  def activate
    @membership.activate!
    @membership.generate_dues_invoice
    _user = @membership.user
    _user.roles = [:member]
    _user.save
    flash[:success] = "Successfully activated #{ @membership.user.full_name }"
    redirect_to '/'
  end

end
