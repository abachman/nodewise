class MembershipsController < ApplicationController
  load_and_authorize_resource

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
