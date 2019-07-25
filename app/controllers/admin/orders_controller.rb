class Admin::OrdersController < Admin::BaseController
  def ship
    order = Order.find(params[:id])
    order.update(status: 'shipped')
    redirect_to '/admin'
  end
end
