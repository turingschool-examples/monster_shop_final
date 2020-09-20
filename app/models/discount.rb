class Discount < ApplicationRecord
    has_many :discount_order_items
    has_many :order_items, through: :discount_order_items
    has_many :items, through: :order_items
    has_many :orders, through: :order_items
    validates_presence_of :discount_percentage, :threshold_quantity
    belongs_to :merchant
end
