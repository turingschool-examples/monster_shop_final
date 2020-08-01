class Discount < ApplicationRecord
  has_many :merchant_discounts
  has_many :merchants, through: :merchant_discounts

  validates_presence_of :percent,
                        :req_inventory

end
