class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def new
    @user = current_user
  end

  def edit
    @order = Order.find(params[:id])
    @address = @order.address
    @user = @order.user
  end

  def update
    @order = Order.find(params[:id])
    @address = Address.find(params[:format])
    @order.update(address: @address)
    redirect_to '/profile/orders'
  end

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    address = Address.find(params[:format])
    order = current_user.orders.new
    order.update(address_id: address.id)
    order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
