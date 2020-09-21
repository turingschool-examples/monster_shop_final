class DiscountOrderItem < ApplicationRecord
    belongs_to :discount
    belongs_to :order_item
end
