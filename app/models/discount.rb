class Discount < ApplicationRecord
  belongs_to :item
  belongs_to :merchant

  validates_presence_of :item_id
  validates_presence_of :merchant_id
  validates_presence_of :threshold, greater_than: 0
  validates_presence_of :discount, in: 0..1

end
