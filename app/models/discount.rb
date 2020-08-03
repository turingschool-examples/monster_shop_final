class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage,
                        :item_amount,
                        :description

  validates  :percentage, numericality: { :only_integer => true, :less_than => 100 }
  validates  :item_amount, numericality: { :only_integer => true, :greater_than => 0 }
end
