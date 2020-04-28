class CartController < ApplicationController
  before_action :exclude_admin

  def create
    item = Item.find(params[:item_id])
    session[:cart] ||= {}
    if cart.limit_reached?(item.id)
      flash[:notice] = "You have all the item's inventory in your cart already!"
    else
      cart.add_item(item.id.to_s)
      session[:cart] = cart.contents
      flash[:notice] = "#{item.name} has been added to your cart!"
    end
    redirect_to items_path
  end

  def index
  end

  def destroy
    if params[:id] == "all"
      session.delete(:cart)
      redirect_to '/cart'
    else
      session[:cart].delete(params[:id])
      redirect_to '/cart'
    end
  end

  def update
    if params[:change] == "more"
      cart.add_item(params[:id])
    elsif params[:change] == "less"
      cart.less_item(params[:id])
      return destroy if cart.count_of(params[:id]) == 0
    end
    session[:cart] = cart.contents
    redirect_to '/cart'
  end
end
