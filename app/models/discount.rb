class Discount < ApplicationRecord
  validates_presence_of :percent_off, :minimum_quantity
  belongs_to :merchant
end