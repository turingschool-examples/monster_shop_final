class Merchant::DiscountsController < Merchant::BaseController
  def index
    @user = User.find(session[:user_id])
    @merchant = Merchant.find(@user.merchant_id)
  end
end