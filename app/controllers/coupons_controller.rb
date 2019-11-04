# frozen_string_literal: true

class CouponsController < ApplicationController
  def create
    coupon = Coupon.find(params[:coupon_id])
    session[:current_coupon] = coupon
    redirect_to cart_path
  end
end
