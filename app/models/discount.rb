class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :rate, :quantity
  validates_numericality_of :rate, greater_than: 0, less_than_or_equal_to: 100
  validates_numericality_of :quantity, greater_than: 0
end
