class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      render :new
    end
  end

  private
  def discount_params
    params.permit(:percentage, :required_amount)
  end
end
