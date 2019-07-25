class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @merchant = current_user.merchant
  end

  def fulfill
    order_item = OrderItem.find(params[:order_item_id])
    order_item.fulfill if order_item.fulfillable?
    redirect_to "/merchant/orders/#{params[:id]}"
  end
end
