class Discount < ApplicationRecord
  validates_presence_of :percent
  validates_presence_of :quantity
  validates_numericality_of :percent
  validates_numericality_of :quantity  
  belongs_to :merchant
end
