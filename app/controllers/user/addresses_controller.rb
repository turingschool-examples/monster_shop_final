class User::AddressesController < ApplicationController

  def new
    @user = current_user

    @address = Address.new(user_id: @user.id)
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      redirect_to profile_path
    else
      render :new
    end
  end

  private

  def address_params
    params.permit(:streetname, :city, :state, :zip)
  end

end
