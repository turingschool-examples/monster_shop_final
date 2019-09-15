class User::AddressesController < User::BaseController

  def new
    @user = User.find(params[:format])
    @address = @user.addresses.build
  end

  def create
    @user = User.find(params[:id])
    @address = @user.addresses.create(address_params)
    redirect_to profile_path
  end

  def edit
    @address = Address.find(params[:format])
  end

  def update
    @address = Address.find(params[:id])
    @address.update(address_params)
    redirect_to profile_path
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:address, :city, :state, :zip)
  end

end
