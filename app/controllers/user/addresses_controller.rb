class User::AddressesController < User::BaseController

  def new

  end

  def edit

  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

end
