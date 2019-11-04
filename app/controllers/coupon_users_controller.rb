# frozen_string_literal: true

class CouponUsersController < ApplicationController
  def create
    CouponUser.create(coupon_id: current_coupon.id, user_id: current_user.id, order_id: params[:order_id])
    flash[:notice] = 'Order created successfully!'
    flash[:notice] = "You have used the #{current_coupon.name} coupon"
    session.delete(:current_coupon)
    redirect_to '/profile/orders'
  end
end
