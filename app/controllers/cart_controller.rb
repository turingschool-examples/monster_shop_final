class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    session[:cart] ||= {}
    cart.add_item(item.id.to_s)
    session[:cart] = cart.contents
    flash[:notice] = "#{item.name} has been added to your cart!"
    redirect_to items_path
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end
end
