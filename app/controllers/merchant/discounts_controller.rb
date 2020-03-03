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

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "Discount Was Created!"
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      redirect_to "/merchant/discounts/new"
    end

  end

  def destroy
    discount = Discount.find(params[:discount_id])
    if discount.has_not_been_used(discount.id)
      discount.destroy
      flash[:success] = "Discount Was Deleted"
      redirect_to '/merchant/discounts'
    else
      flash[:error] = "Unable to Delete Discount. This discount has been used."
      redirect_to '/merchant/discounts'
    end
  end

  private

    def discount_params
      params.permit(:percent_off, :quantity_threshold, :status)
    end

end
