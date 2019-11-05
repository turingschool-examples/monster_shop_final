# frozen_string_literal: true

class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :coupon_users

  validates_presence_of :name,
                        :discount

  validates_numericality_of :discount, greater_than: 0

  validates_uniqueness_of :name

  def used?
    coupon_users.select(:user_id).where(coupon_id: id)
  end
end
