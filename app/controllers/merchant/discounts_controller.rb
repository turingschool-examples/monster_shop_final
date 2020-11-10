class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:id])
  end
end
