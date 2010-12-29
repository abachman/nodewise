#user_controller.rb
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  before_filter :find_user, :only => [:show]
  before_filter :find_user_by_id, :only => [:edit, :update, :destroy, :send_overdue, :send_reminder]

  load_and_authorize_resource :except => [:show, :index]

  def index
    if user_signed_in?
      @users = User.all
    else
      @users = User.public
    end
  end

  def show
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      if @user == current_user
        flash[:notice] = "Successfully updated your profile."
      else
        flash[:notice] = "Successfully updated #{ @user.username }'s profile."
      end
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to root_path
    end
  end

protected
  def find_user
    if user_signed_in?
      @user = User.with_username params[:username]
    else
      @user = User.public.with_username params[:username]
    end

    user_check
  end

  def find_user_by_id
    @user = User.find_by_id(params[:id])
    user_check
  end

  def user_check
    if @user.nil?
      flash[:error] = "Sorry, we couldn't find that user."
      redirect_to root_url
      false
    else
      true
    end
  end
end
