class Discount < ApplicationRecord
  validates_numericality_of :discount, :in => 1..100
end
