class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def calculate_price
    self.subtotal / self.quantity
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
