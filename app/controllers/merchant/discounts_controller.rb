class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
    # @discounts = Merchant.find(current_user.id).discounts
  end

  def new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "New discount created!"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:success] = "Discount was successfully updated!"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    flash[:success] = "Discount was successfully deleted!"
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:name, :item_amount, :discount_percentage)
  end

end
