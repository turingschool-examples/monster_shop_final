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
    Discount.update(params[:id], discount_params)
    redirect_to merchant_bulk_discounts_path
  end

end


private

def discount_params
   params.require(:discount).permit(:percentage, :bulk)
 end
