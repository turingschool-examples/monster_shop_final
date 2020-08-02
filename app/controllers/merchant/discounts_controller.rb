class Merchant::DiscountsController < Merchant::BaseController
  def index
    merchant = Merchant.find(current_user.merchant_id)
    @discounts = merchant.discounts
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = @merchant.discounts.new
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.create(discount_params)

    if @discount.save
      redirect_to '/merchant/discounts'
      flash[:message] = 'Discount successfully created'
    else
      redirect_to '/merchant/discounts/new'
      flash[:error] = @discount.errors.full_messages.to_sentence
    end
  end

  def edit
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:format])
    @discount.update(discount_params)

    if @discount.update(discount_params)
      redirect_to '/merchant/discounts'
      flash[:message] = "Discount #{@discount.id} successfully updated"
    else
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
      flash[:error] = @discount.errors.full_messages.to_sentence
    end
  end

  def change_status
    redirect_to '/merchant/discounts'

  end

  private

  def discount_params
    params.require(:discount).permit(:percent, :quantity)
  end
end
