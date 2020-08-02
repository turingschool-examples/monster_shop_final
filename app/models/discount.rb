class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage,
                        :item_amount,
                        :description

#  validates :percentage, numerically: { :only_integer }                      
end
