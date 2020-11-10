class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
  end

  def create
  @merchant = Merchant.find_by(id: current_user.merchant_id)
    @discount = @merchant.discounts.create(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path
    else
      generate_flash(@discount)
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
    @discount.update(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(@discount)
      render :edit
    end
  end

  private

  def discount_params
    params.permit(:rate, :quantity)
  end
end
