class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    @users = User.all

    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
    
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    redirect_to admin_users_path
  end
  
  def contact_form
    @user = current_or_guest_user
  end
  
  def contact_send
    redirect_to root_path, :notice => params[:user][:name]
  end
  
  def user_params
    list_params_allowed = [:name,:email]
    list_params_allowed << :role_id << :approved if current_user.admin?
    params.require(:user).permit(list_params_allowed)
  end

  
end
