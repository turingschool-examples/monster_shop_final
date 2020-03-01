class ItemDiscount < ApplicationRecord
  belongs_to :item
  belongs_to :discount
end
