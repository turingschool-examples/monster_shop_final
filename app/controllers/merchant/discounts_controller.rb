class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = User.find(session[:user_id]).merchant
    @discounts = @merchant.discounts
  end

end
