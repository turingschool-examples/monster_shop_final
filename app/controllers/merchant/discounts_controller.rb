class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end
end
