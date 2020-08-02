class Merchant::DiscountsController < Merchant::BaseController
  def index
    merchant = Merchant.find(current_user.merchant_id)
    @discounts = merchant.discounts
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = @merchant.discounts.new
  end

  def edit

  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :quantity)
  end
end
