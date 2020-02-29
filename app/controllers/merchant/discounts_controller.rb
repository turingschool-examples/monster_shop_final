class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @items = current_user.merchant.items
  end

  def create

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