class Merchant::BaseController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user.merchant
    @discounts = @merchant.discounts
  end
  
end
