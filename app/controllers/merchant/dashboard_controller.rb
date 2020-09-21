class Merchant::DashboardController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @discounts = @merchant.discounts
  end
end
