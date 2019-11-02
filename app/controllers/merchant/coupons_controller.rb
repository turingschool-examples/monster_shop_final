# frozen_string_literal: true

class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def new; end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.new(coupon_params)
    if coupon.save
      redirect_to '/merchant/coupons'
    else
      generate_flash(merchant)
      render :new
    end
  end

  private

  def coupon_params
    params.permit(:name, :discount)
  end
end
