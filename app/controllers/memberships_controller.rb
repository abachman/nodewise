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
  end

  def destroy
  end

end
