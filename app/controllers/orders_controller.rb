class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end

  def new
  end

  def create
    order = Order.new(order_params)
    if order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to order_path(order)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
