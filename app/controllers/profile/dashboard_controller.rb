class Profile::DashboardController < Profile::BaseController
  def index
    @user = current_user
  end

  def edit
    @user = current_user
    if params[:password] == "true"
      render :edit_password
    else
      render :edit
    end
  end
end