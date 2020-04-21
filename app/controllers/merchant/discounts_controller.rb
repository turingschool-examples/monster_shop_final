class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    Discount.update(params[:discount_id], discount_params)
    redirect_to "/merchant/discounts"
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to "merchant/discounts"
  end
end

private

def discount_params
   params.permit(:percentage, :bulk)
 end
