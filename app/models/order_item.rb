class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    if item.discount.nil? || quantity < item.discount.quantity
      quantity * price
    else
      discounted_subtotal
    end
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def discounted_subtotal
    items_at_full_price = quantity - item.discount.quantity
    discount = item.discount.percent.to_f / 100
    discounted_price = item.price - (item.price * discount)
    cost_full_price_items = item.price * items_at_full_price
    cost_discounted_items = discounted_price * item.discount.quantity
    (cost_full_price_items + cost_discounted_items).round(2)
  end
end
