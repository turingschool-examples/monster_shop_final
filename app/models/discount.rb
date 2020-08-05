class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name,
                        :percent_off,
                        :min_quantity

  validates  :percent_off, numericality: { :only_integer => true, :less_than_or_equal_to => 100 }
  validates  :min_quantity, numericality: { :only_integer => true, :greater_than => 0 }

end
