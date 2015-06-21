class UsersController < ApplicationController
 load_and_authorize_resource
 def index
    @users = User.all
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
      redirect_to users_path
    else
      render 'edit'
    end
    
  end
  
  def user_params
    params.require(:user).permit(:admin,:approved)
  end
    
end
