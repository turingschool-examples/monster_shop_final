class DiscountItem < ApplicationRecord
    belongs_to :discount
    belongs_to :item
end
