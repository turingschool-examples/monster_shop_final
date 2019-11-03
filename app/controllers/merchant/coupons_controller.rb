# frozen_string_literal: true

class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = current_user.merchant.coupons
  end

  def new; end

  def create
    merchant = current_user.merchant
    if merchant.coupons.count >= 5
      flash[:notice] = 'You already have 5 coupons, which is the limit'
      redirect_to '/merchant/coupons'
    elsif merchant.coupons.count <= 4
      coupon = merchant.coupons.create(coupon_params)
      if coupon.save
        flash[:notice] = 'You have created a new coupon'
        redirect_to '/merchant/coupons'
      else
        flash[:notice] = coupon.errors.full_messages.to_sentence
        render :new
      end
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
      flash[:notice] = coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def disable_enable
    coupon = Coupon.find(params[:id])
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
