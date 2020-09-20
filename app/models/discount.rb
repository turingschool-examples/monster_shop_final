class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :order_discounts
  has_many :orders, through: :order_discounts

  validates_presence_of :percent, :min_items

  def self.active_discounts
    where(active: true)
  end
end
