class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.where(merchant: current_user.merchant)
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to merchant_discounts_path
    else
      generate_flash(item)
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update_attributes(discount_params)
      redirect_to merchant_discount_path(@discount)
    else
      render :edit
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.permit(:percent_off, :minimum_quantity)
  end
end