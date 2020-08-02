class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:notice] = "Please fill out both fields"
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
  end

  private
  def discount_params
    params.permit(:percentage, :required_amount)
  end
end
