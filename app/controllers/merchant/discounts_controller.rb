class Merchant::DiscountsController < Merchant::BaseController
  def index
    @user = current_user
  end

  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to '/merchant/discounts'
    end
  end

  private
  def discount_params
    params.permit(:description, :quantity, :percent)
  end
end
