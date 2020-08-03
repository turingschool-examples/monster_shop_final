class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_merchant.discounts
  end

  def new
  end

  def create
    @discount = current_merchant.discounts.create(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
      flash[:message] = "New discount created!"
    else
      redirect_to '/merchant/discounts/new'
      flash[:error] = @discount.errors.full_messages.to_sentence
    end
  end

  private
  def discount_params
    params.permit(:percentage, :item_amount, :description)
  end

  def current_merchant
    current_user.merchant
  end
end
