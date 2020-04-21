class Discount < ApplicationRecord
  belongs_to :merchant

  validates_inclusion_of :percentage, in: 1..99, message: "Percentage must be 1 - 99"
  validates_numericality_of :quantity, greater_than: 0

  def calculation_percentage
    (100 - percentage) * 0.01
  end
end