class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  before_filter :load_payments_and_invoices_for_user, :only => [:edit]

  def index
  end

  def show
  end

  def edit
    @user = @membership.user
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

  def destroy
  end

end
