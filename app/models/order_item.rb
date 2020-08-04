class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    if applicable_discount.nil? || quantity < applicable_discount.quantity
      quantity * price
    else
      discounted_subtotal
    end
  end

  def savings
    ((quantity * price) - subtotal).round(2)
  end

  def blended_price
    (subtotal / quantity).round(2)
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def applicable_discount
    count = quantity
    item.discount.where("#{quantity} >= quantity").order('percent DESC').limit(1).first
  end

  def discounted_subtotal
    items_at_full_price = quantity - applicable_discount.quantity
    percent = applicable_discount.percent.to_f / 100
    discounted_price = item.price - (item.price * percent)
    cost_full_price_items = item.price * items_at_full_price
    cost_discounted_items = discounted_price * applicable_discount.quantity
    (cost_full_price_items + cost_discounted_items).round(2)
  end
end
