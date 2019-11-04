# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders
  has_many :coupon_users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :email

  validates_uniqueness_of :email

  enum role: %w[default merchant_admin admin]

  def find_coupon(order)
    coupon_users.select(:coupon_id).where(order_id: order.id)
  end
end
