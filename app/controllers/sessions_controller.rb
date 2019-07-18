class SessionsController < ApplicationController
  def new
  end

  def login
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id if user.authenticate(params[:password])
    if current_merchant_user?
      redirect_to merchant_dashboard_path
    elsif current_admin?
      redirect_to admin_dashboard_path
    else
      redirect_to profile_path
    end
  end

  def logout
    redirect_to root_path
  end
end
