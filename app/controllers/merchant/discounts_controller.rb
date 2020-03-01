class Merchant::DiscountsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items
  end

  def new
    @items = current_user.merchant.items
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      discount.create_item_discounts(params[:items][:item_ids], params[:amount], params[:num_items])
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      render :new
    end
  end

  def edit
    
  end

  def update

  end

  def destroy

  end

  private

  def discount_params
    params.permit(:amount, :num_items)
  end
end