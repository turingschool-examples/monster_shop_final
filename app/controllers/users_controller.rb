class UsersController < ApplicationController
  before_action :require_user, only: :show
  before_action :exclude_admin, only: :show

  def show
    @user = current_user
    @address = Address.find(@user.default_address)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    address = @user.addresses.new(address_params)

    if @user.save && address.save
      @user.assign_address(address.id)
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.name}!"
      redirect_to profile_path
    else

      flash.now[:error] = @user.errors.full_messages.to_sentence.gsub("Addresses", '')
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

  def assign_default
    user = current_user
    address = Address.find(params[:address_id])

    if user.assign_address(params[:address_id])
      flash[:success] = "You have set '#{address.nickname}' as your default address"
      redirect_to profile_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :default_address) #, addresses_attributes: [ :address, :city, :state, :zip ]) for accepts_nested_attributes_for :addresses *in the user model*
  end

  def address_params
    params.require(:address).permit(:street_address, :city, :state, :zip, :nickname)
  end
end
