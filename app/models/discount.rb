class Discount < ApplicationRecord
  belongs_to :item
  belongs_to :merchant

  validates_presence_of :item_id
  validates_presence_of :merchant_id
  validates_presence_of :threshold
  validates_numericality_of :threshold, greater_than: 0
  validates_presence_of :discount
  validates_numericality_of :discount, greater_than: 0
  validates_numericality_of :discount, less_than: 1

end
