# frozen_string_literal: true

class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def new; end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save && merchant.coupons.count <= 5
      redirect_to '/merchant/coupons'
    else
      flash[:notice] = 'You already have 5 coupons, which is the limit.'
      redirect_to new_merchant_coupon_path
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    coupon = Coupon.find(params[:id])
    if coupon.update(coupon_params)
      redirect_to '/merchant/coupons'
    else
      generate_flash(coupon)
      render :edit
    end
  end

  def disable_enable
    coupon = Coupon.find(params[:id])
    # binding.pry
    coupon.toggle!(:enabled?)
    flash[:notice] = if coupon.enabled?
                       "#{coupon.name} is now enabled"
                     else
                       "#{coupon.name} is now disabled"
                     end
    redirect_to merchant_coupons_path
  end

  private

  def coupon_params
    params.permit(:name, :discount)
  end
end
