class Discount < ApplicationRecord

  belongs_to :merchant

  validates_presence_of :name
  validates_numericality_of :item_amount, greater_than: 0
  validates_inclusion_of :discount_percentage, in: 1..99, message: "Discount percentage must be 1 - 99"

end
