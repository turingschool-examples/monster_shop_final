class Discount < ApplicationRecord
  has_many :merchant_discounts
  has_many :merchants, through: :merchant_discounts
end
