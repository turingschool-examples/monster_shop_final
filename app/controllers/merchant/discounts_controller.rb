class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = current_user.merchant.discounts
  end
end
