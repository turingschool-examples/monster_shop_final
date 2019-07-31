class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
    if current_user.addresses.empty?
      redirect_to new_address_path
      flash[:error] = "Order is missing address, create address to proceed"
    elsif @order.address.nil?
      redirect_to change_address_path(@order.id)
      flash[:error] = "Address must be associated with order, select an address"
    end
  end

  def create
    address = Address.find(params[:address_id])
    order = current_user.orders.create!(address_id: address.id)
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

  def select_address
    if current_user.addresses.empty?
      redirect_to new_address_path
      flash[:error] = "Address must be added to continue checkout"
    end
    @user_addresses = current_user.addresses
  end

  def change_address
    @user_addresses = current_user.addresses
    @order = Order.find(params[:order_id])
  end

  def update_order_address
    new_address = Address.find(params[:address_id])
    order = Order.find(params[:order_id])
    if order.status == 'pending'
      order.update(address_id: new_address.id)
      flash[:success] = "Address has been changed successfully"
    end
    redirect_to "/profile/orders/#{order.id}"
  end
end
