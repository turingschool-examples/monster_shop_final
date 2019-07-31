class AddressesController < ApplicationController
  # before_action :require_user, only: :show
  # before_action :exclude_admin, only: :show

  #I don't think I even need an Addresses Controller at this time.
  def index
    @user = current_user
    @addresses = @user.addresses.all
  end

  def show
    @user = current_user
    @address = Address.find(params[:id])
  end

  def new
  @address = Address.new
  end

  def create
    @user = current_user
    @address = @user.addresses.create!(object_params)

    if @address.id.nil?
      flash[:notice] = "Please complete all fields"
      render :new
    else
      flash[:notice] = "Your New Address Has Been Saved!"
    end
    redirect_to profile_path
  end

  def edit
    @user = current_user
    @address = Address.find(params[:id])
  end

  def update
    @user = current_user
    @address = Address.find(params[:id])
    @user.addresses.update(object_params)

    #could sad and happy path here
    redirect_to profile_path
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    redirect_to profile_path 
  end

  private

  def object_params
    params.require(:address).permit(:street_address, :city, :state, :zip, :nickname)
  end

  def address_params
    params.require(:user).require(:address).permit(:street_address, :city, :state, :zip, :nickname)
  end
end
