class Merchant::CouponsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
  end

  def new
  end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save
      flash[:success] = "Coupon Created!"
      redirect_to '/merchant/coupons'
    else
      flash[:error] = "Please enter valid coupon info."
      redirect_to '/merchant/coupons/new'
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :percentage)
  end
end
