class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :items_required, :discount
  validates_numericality_of :items_required, greater_than: 0
  validates_numericality_of :discount, greater_than: 0
end
