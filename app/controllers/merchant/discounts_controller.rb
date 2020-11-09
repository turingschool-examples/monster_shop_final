class Merchant::DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end
  
  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      flash.now[:error]= @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Discount.delete(params[:id])
    redirect_to "/merchant/discounts"
  end

  def new
    @discount = Discount.new
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Item.find(discount_params[:item_id]).discounts.create(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      flash.now[:error]= @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private
  def discount_params
    params[:discount].permit(:item_id, :threshold, :discount)
  end

end

