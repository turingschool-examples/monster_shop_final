class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    # require "pry"; binding.pry
    @discount = Discount.new(discount_params)
    if @discount.save
      flash[:success] = 'Your discount has been created.'
      redirect_to "/merchant/discounts"
    else
      flash[:errors] = @discount.errors.full_messages
      redirect_to "/merchant/discounts/new"
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :item_minimum, :percent, :merchant_id)
  end
end
