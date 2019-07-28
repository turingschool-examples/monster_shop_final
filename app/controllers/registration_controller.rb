class RegistrationController < ApplicationController
  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)

    if @registration.save
      session[:user_id] = @registration.user.id
      flash[:notice] = "Welcome, #{@registration.user.name}!"
      redirect_to profile_path
    else
      generate_flash(@registration)
      render :new
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
