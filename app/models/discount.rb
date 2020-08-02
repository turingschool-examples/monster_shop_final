class Discount < ApplicationRecord
  validates_presence_of :percent
  validates_presence_of :quantity
  validates_numericality_of :percent
  validates_numericality_of :quantity
  validates_uniqueness_of :merchant_id, scope: [:percent, :quantity], message: "This discount already exists"
  belongs_to :merchant
end
