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

  def destroy
    address = Address.find(params[:id])
    if address.orders.empty?
      address.destroy
    else
      address.orders.each do |order|
        if order.status == 'shipped'
          flash[:error] = "Address can't be deleted"
        else
          address.destroy
        end
      end
    end
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end
end
