class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.all
  end
end
