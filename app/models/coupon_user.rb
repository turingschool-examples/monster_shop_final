# frozen_string_literal: true

class CouponUser < ApplicationRecord
  belongs_to :coupon
  belongs_to :user
end
