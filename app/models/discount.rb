class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percentage,
                        :required_amount
end
