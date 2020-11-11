class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    discount = Discount.where(item_id: item_id)
                       .where("discounts.minimum_quantity <= ?", quantity)
                       .order(percentage: :desc)
                       .first

    full_price = quantity * price
    if discount
      discount_price(full_price, discount.percentage)
    else
      full_price
    end
  end

  def discount_price(full_price, percentage_off)
    full_price - (full_price * (percentage_off.to_f/100))
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
