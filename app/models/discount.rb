class Discount < ApplicationRecord
  validates_presence_of :quantity, :amount
  validates_numericality_of :amount, :in => 1..100
  belongs_to :merchant
end
