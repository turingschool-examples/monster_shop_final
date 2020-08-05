class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    ordered_discounts = item.discounts.order(:item_amount)
    if ordered_discounts.where("item_amount <= #{quantity}").empty?
      quantity * price
    else
      discount = quantity * price * ordered_discounts.where("item_amount <= #{quantity}").last.percentage.to_f / 100
      quantity * price - discount
    end
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
