class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
