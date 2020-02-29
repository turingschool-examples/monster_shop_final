class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  private

  def item_params
    params.permit(:percent_off, :quantity_threshold, :status)
  end

end
