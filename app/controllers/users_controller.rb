class UsersController < ApplicationController
  before_action :require_user, only: :show
  before_action :exclude_admin, only: :show

  def new
    @user = User.new
    @address = @user.addresses.new

    # 23.times{@user.addresses.build}
    # @user.addresses.new
    #not sure if the above is necessary
  end

  def show
    @user = current_user
    # @addresses = @user.addresses
  end


  def create
    @user = User.create(user_params)
    if @user.save
      @address = @user.addresses.create!(address_params)
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
    @address = @user.addresses
  end

  def edit_password
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      @user.addresses.update(address_params)

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
    params.require(:user).require(:address).permit(:street_address, :city, :state, :zip, :nickname)
  end
end

# params[:user][:address][:street_address]
