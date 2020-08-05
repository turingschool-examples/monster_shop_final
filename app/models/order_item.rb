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
    new_price = (subtotal / quantity).round(2)
    update(price: new_price)
    new_price
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
    item.discount.where("#{count} >= quantity").order('percent DESC').limit(1).first
  end

  def discounted_subtotal
    percent = 1 - (applicable_discount.percent.to_f / 100)
    discounted_price = item.price * percent
    quantity * discounted_price.round(2)
  end
end
