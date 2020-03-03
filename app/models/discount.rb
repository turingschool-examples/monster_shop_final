class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :title,
                        :percent_off,
                        :information,
                        :lowest_amount,
                        :highest_amount

  def discount_range
    "#{lowest_amount} - #{highest_amount} items"
  end
end
