class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end
end
