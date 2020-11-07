class Merchant::DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end
  
  def edit
    @discount = Discount.find(params[:id])
  end

  def destroy
    Discount.delete(params[:id])
    redirect_to "/merchant/discounts"
  end

end

