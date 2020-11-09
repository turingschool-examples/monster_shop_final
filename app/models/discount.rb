class Discount < ApplicationRecord
  belongs_to :item

  validates_presence_of :name,
                        :percentage,
                        :minimum_quantity
end
