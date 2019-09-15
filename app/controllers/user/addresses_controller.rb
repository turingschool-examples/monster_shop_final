class User::AddressesController < User::BaseController

  def new
    @user = User.find(params[:format])
    @address = @user.addresses.build
  end

  def create
    
  end

  def edit

  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to profile_path
  end

end
