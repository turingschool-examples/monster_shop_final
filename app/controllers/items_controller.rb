class ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.active_items
    end
  end

  def show
    @item = Item.find(params[:id])
  end
end
