class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent_off, :minimum_quantity
  validates :percent_off, numericality: { only_integer: true, greater_than: 0 }
  validates :minimum_quantity, numericality: { only_integer: true, greater_than: 0 }
end