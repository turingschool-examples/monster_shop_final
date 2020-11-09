class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_inclusion_of :percentage_discount, in: 1..100, message:  "Discount must be percentage from 1 - 100"
  validates :bulk_quantity, numericality: { greater_than: 0 }
end
