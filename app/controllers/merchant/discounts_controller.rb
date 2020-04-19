class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      render :new
    end
  end

  # def create
  #   merchant = current_user.merchant
  #   item = merchant.items.new(item_params)
  #   if item.save
  #     redirect_to "/merchant/items"
  #   else
  #     generate_flash(item)
  #     render :new
  #   end
  # end

  private
  def discount_params
    params.permit(:quantity, :percentage)
  end
end