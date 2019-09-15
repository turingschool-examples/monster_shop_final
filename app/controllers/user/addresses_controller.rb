class User::AddressesController < User::BaseController

  def new
    @user = current_user
    @address = @user.addresses.build
  end

  def create
    @user = current_user
    @address = @user.addresses.new(address_params)
    if @address.save
      redirect_to profile_path
    else
      generate_flash(@address)
      render :new
    end
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
