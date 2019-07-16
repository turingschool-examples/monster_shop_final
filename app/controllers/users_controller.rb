class UsersController < ApplicationController
  def show
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    session[:user_id] = user.id
    flash[:notice] = "Welcome, #{user.name}!"
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
