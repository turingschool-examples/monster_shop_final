class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    @discount.save
    flash[:success] = "New discount created!"
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:name, :item_amount, :discount_percentage)
  end

end
