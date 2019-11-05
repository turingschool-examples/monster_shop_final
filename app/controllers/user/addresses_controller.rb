class User::AddressesController < ApplicationController
  before_action :require_user

  def show
    @address = Address.find(params[:id])
  end

  def index
    @user = current_user
    @addresses = @user.addresses
  end

  def new
  end

  def create
    user = current_user #User.find(params[:user_id])
    if user.nickname_uniq?(address_params[:nickname])
      address = user.addresses.new(address_params)
      if address.save && params[:default_address] == '1'
        user.assign_address(address.id)
        flash[:success] = "You have created your #{address.nickname} address."
        flash[:notice] = "You have set '#{address.nickname}' as your default address"
        redirect_to profile_path
      elsif address.save && params[:default_address] != '1'
        flash[:success] = "You have created your #{address.nickname} address."
        redirect_to profile_path
      else
        generate_flash(address)
        render :new
      end
    else
      flash[:error] = "That nickname is already taken"
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "You have updated your #{@address.nickname} address"
      redirect_to profile_path if @address.user.current_address?(@address.id)
      redirect_to addresses_path unless @address.user.current_address?(@address.id)
    else
      generate_flash(@address)
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address_name = address.nickname

    user = address.user
    user.assign_address(nil) if user.default_address == params[:id]
    address.destroy
    if user.addresses.size == 1
      user.assign_address(user.addresses[0].id)
      flash[:success] = "You have deleted your #{address_name} address."
      flash[:notice] = "#{user.addresses[0].nickname} has been set to your default address"
      redirect_to profile_path
    else
      flash[:success] = "You have deleted your #{address_name} address."
      flash[:notice] = "You should choose or create a new default address"
      redirect_to addresses_path
    end
  end

  def assign_default
    user = current_user
    user.assign_address(params[:address_id])
  end

  private
    def address_params
      params.permit(:street_address, :city, :state, :zip, :nickname)
    end
end
