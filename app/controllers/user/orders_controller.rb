class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end


  def create
    order = current_user.orders.new
    binding.pry
    order.save
      cart.items.each do |item|
        order.order_items.create({
          # Order.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price,
          # order: order
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

# def create
#   order = current_user.orders.new
#   if  @user.address_id == nil
#     flash[:notice] = "An address is required to checkout."
#     redirect_to new_user_address_path(@user.id)
#    else order.save
#     cart.items.each do |item|
#       order.order_items.create!({
#         # Order.create({
#         item: item,
#         quantity: cart.count_of(item.id),
#         price: item.price,
#         order: order
#         })
#     end
#       session.delete(:cart)
#       flash[:notice] = "Order created successfully!"
#       redirect_to '/profile/orders'
#   end
# end
