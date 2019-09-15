class UsersController < ApplicationController
  before_action :require_user, only: :show
  before_action :exclude_admin, only: :show

  def show
    @user = current_user
  end

  def new
    @user = User.new
    @user.addresses.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.addresses.create(address_params)
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.name}!"
      redirect_to profile_path
    else
      generate_flash(@user)
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def edit_password
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'Profile has been updated!'
      redirect_to profile_path
    else
      generate_flash(@user)
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def address_params
    params.require(:user).require(:addresses).permit(:address, :city, :state, :zip)
  end
end
