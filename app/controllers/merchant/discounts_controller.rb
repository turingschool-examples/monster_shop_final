class Merchant::DiscountsController < Merchant::BaseController

  def index
    merchant = Merchant.find(current_merchant.id)
    @discounts = merchant.discounts
  end

  def new
  end

  def create
    @discount = current_merchant.discounts.create(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
      flash[:message] = "New Bulk Discount Created"
    else
      redirect_to '/merchant/discounts/new'
      flash[:error] = @discount.errors.full_messages.to_sentence
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    if discount.save
      redirect_to '/merchant/discounts'
      flash[:message] = "Discount Updated"
    else
      redirect_to "/merchant/discounts/#{discount.id}/edit"
      flash[:error] = discount.errors.full_messages.to_sentence
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
    flash[:message] = "#{discount.name} Deleted"
  end

  private

  def discount_params
    params.permit(:name, :percent_off, :min_quantity)
  end

  def current_merchant
    current_user.merchant
  end
end
