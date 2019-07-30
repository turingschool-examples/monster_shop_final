class User::AddressesController < ApplicationController
  def new
    @address = current_user.addresses.new
  end

private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
