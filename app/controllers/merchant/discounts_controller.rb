class Merchant::DiscountsController < Merchant::BaseController

  def new
  end

  def index
    @discounts = current_user.merchant.all_discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def create
    item = Item.find_by(name: params["Item Name"])
    discount = Discount.new(discount_params)
    if item
      discount.item_id = item.id
      if discount.save
        redirect_to "/merchant/discounts"
      else
        generate_flash(discount)
        render :new
      end
    else
      flash[:notice] = "Item could not be found"
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
  end

  private

  def discount_params
    params.permit(:name, :percentage, :minimum_quantity)
  end
end
