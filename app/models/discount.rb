class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :items_req, :discount
  validates_numericality_of :items_req, greater_than: 0
  validates_numericality_of :discount, greater_than: 0
end
