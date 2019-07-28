class RegistrationController < ApplicationController
  def new
    @registration = Registration.new
  end

  def create
    @register = Registration.new(registration_params)

    if @register.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.name}!"
      redirect_to profile_path
      binding.pry
    else
      generate_flash(@user)
      render :new
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
