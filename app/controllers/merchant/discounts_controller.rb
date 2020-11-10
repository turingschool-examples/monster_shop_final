class Merchant::DiscountsController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end 

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.new
  end

  def create 
  end 

  def edit 
    @discount = Discount.find(params[:discount_id])
    @merchant = @discount.merchant
  end

  def update
    discount = Discount.find(params[:discount_id])
    discount.update(discount_params)
    merchant = discount.merchant
    redirect_to "/merchant/#{merchant.id}/discounts/index"
  end

  def delete 
    discount = Discount.find(params[:discount_id])
    merchant = discount.merchant
    Discount.destroy(params[:discount_id])
    redirect_to "/merchant/#{merchant.id}/discounts/index"
  end

  private

  def discount_params
    params[:discount].permit(:percent_off, :item_requirement)
  end

end 