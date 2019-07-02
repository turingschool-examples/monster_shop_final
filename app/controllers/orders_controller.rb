class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
  end

  def create
    order = Order.create(order_params)
    cart.items.each do |item|
      order.order_items.create({
        item: item,
        quantity: cart.count_of(item.id),
        price: item.price
        })
    end
    session.delete(:cart)
    redirect_to order_path(order)
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
