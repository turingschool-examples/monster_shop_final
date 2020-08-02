class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name,
                        :percent_off,
                        :min_quantity

  validates  :percent_off
  validates  :min_quantity



end
