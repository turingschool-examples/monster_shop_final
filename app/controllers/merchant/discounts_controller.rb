class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.where(merchant: current_user.merchant)
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to merchant_discounts_path
    else
      generate_flash(item)
      render :new
    end
  end

  private

  def discount_params
    params.permit(:percent_off, :minimum_quantity)
  end
end