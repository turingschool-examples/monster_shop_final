class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    quantity * price
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def discounted_subtotal
    discounted_price

    quantity * price
  end

  def discounted_price
    if item.discount_eligible(quantity)
      new_price = price - (price * (item.discount_eligible(quantity).rate / 100))
      update(price: new_price)
    end
  end
end
