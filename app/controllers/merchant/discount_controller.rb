class Merchant::DiscountController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

end
