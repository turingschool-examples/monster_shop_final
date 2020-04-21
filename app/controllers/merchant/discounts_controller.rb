class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end
end
