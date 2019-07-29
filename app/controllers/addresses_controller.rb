class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    address = current_user.addresses.new(address_params)
    if address.save
      redirect_to profile_path
    else
      generate_flash(address)
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to profile_path
    else
      generate_flash(@address)
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end
end
