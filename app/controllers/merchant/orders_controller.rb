class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    @merchant = current_user.merchant
  end
end
