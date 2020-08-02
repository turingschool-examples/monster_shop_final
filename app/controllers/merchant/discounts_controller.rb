class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.all
  end

  def new
  end

  def create
    @discount = current_user.merchant.discounts.create(discount_params)
    redirect_to '/merchant/discounts'
    flash[:message] = "New discount created!"
  end

  private
  def discount_params
    params.permit(:percentage, :item_amount, :description)
  end
end
