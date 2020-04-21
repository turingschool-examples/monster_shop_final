class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = Discount.where(merchant_id: current_user.merchant.id)
  end
end
