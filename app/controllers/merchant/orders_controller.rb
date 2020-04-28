class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @merchant = current_user.merchant
  end

  def update
    unless params[:fulfill].nil?
      order = current_user.orders.find(params[:id])
      order_item = order.order_items.find(params[:fulfill])
      order_item.fulfill if order_item.fulfillable?
      order.is_packaged?
      redirect_to "/merchant/orders/#{params[:id]}"
    end
  end
end
