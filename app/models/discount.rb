class Discount < ApplicationRecord
  validates_presence_of :percent
  validates_presence_of :quantity
  belongs_to :merchant
end
