class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end

  def update
    @discount = Discount.find(params[:discount_id])
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      generate_flash(@discount)
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end


  private

    def discount_params
      params.permit(:percent_off, :quantity_threshold, :status)
    end

end
