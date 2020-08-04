class Discount < ApplicationRecord
  validates_presence_of :name, :item_minimum, :percent, :merchant_id 
  belongs_to :merchant
end
