class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.where(merchant: current_user.merchant)
  end
end