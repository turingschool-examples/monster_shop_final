class User::AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses.all
  end
  
  def new
    @address = current_user.addresses.new
  end

  def create
    address = current_user.addresses.new
    address.save(address_params)
    redirect_to profile_path
  end

private

  def address_params
    params.permit(:address, :city, :state, :zip, :nickname)
  end
end
