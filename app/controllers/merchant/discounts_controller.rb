class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      flash[:success] = 'Your discount has been created.'
      redirect_to "/merchant/discounts"
    else
      flash[:errors] = @discount.errors.full_messages
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.valid?
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      flash[:errors] = @discount.errors.full_messages
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :item_minimum, :percent, :merchant_id)
  end
end
