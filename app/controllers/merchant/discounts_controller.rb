class Merchant::DiscountsController < Merchant::BaseController

  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      flash[:alert] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
  params.permit(:name, :percentage, :limit)
  end
  #resources werent providing a prefix on form_with, using form tag
  #def discount_params
  #params.require(:discount).permit(:name, :percentage, :limit)
  #end
end
