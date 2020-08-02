class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name,
                        :percent_off,
                        :min_quantity

end
