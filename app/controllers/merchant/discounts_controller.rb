class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
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
