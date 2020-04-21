class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = Discount.where(merchant_id: current_user.merchant.id)
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new; end

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


  private

  def discount_params
    if params[:percent]
      params[:percent] = params[:percent].to_f / 100
    end
    params.permit(:name, :percent, :threshold)
  end
end
