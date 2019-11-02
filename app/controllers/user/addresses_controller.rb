class User::AddressesController < ApplicationController

  def new
  end

  def create
    @user = current_user #User.find(params[:user_id])
    if @user.nickname_uniq?(address_params[:nickname])
      address = @user.addresses.new(address_params)
      if address.save
        flash[:success] = "You have created your #{address.nickname} address."
        redirect_to profile_path
      else
        generate_flash(address)
        render :new
      end
    end
  end

  private
    def address_params
      params.require(:address).permit(:address, :city, :state, :zip, :nickname)
    end
end
