class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :order_discounts
  has_many :orders, through: :order_discounts

  validates_presence_of :name

  def self.active_discounts
    where(active: true)
  end
end
