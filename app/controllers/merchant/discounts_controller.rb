class Merchant::DiscountsController < Merchant::BaseController

  def index
    merchant = Merchant.find(current_merchant.id)
    @discounts = merchant.discounts
  end

  private

  def current_merchant
    current_user.merchant
  end
end
