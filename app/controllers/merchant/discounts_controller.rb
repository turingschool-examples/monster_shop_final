class Merchant::DiscountsController < Merchant::BaseController

  def new
  end

  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:id])
  end
end
