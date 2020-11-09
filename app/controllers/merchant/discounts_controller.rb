class Merchant::DiscountsController < ApplicationController
  def index 
  end 

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.new
  end

  def create 
  end 

end 