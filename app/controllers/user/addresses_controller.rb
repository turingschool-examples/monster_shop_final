class User::AddressesController < ApplicationController

  def new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      redirect_to profile_path
    else
      generate_flash(@address)
      render :new
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    @address.update(address_params)
    if @address.save
      # binding.pry
      redirect_to profile_path
    else
      generate_flash(@address)
      render :edit
    end
  end

  private

  def address_params
    params.permit(:streetname, :city, :state, :zip, :nickname)
  end

end
