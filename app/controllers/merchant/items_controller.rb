class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items
  end

  def update
    item = Item.find(params[:id])
    item.update(active: !item.active)
    if item.active?
      flash[:notice] = "#{item.name} is now available for sale"
    else
      flash[:notice] = "#{item.name} is no longer for sale"
    end
    redirect_to '/merchant/items'
  end
end
