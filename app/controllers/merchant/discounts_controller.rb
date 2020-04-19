class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.create(discount_params)
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.permit(:quantity, :percentage)
  end
end