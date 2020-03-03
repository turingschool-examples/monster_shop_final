class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :title,
                        :percent_off,
                        :information,
                        :lowest_amount,
                        :highest_amount

end
