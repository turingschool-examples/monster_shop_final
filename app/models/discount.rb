class Discount < ApplicationRecord
    has_many :discount_items
    has_many :items, through: :discount_items
    validates_presence_of :discount_percentage, :threshold_quantity
    belongs_to :merchant
end
