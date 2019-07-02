class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items

  def grand_total
    order_items.sum('price * quantity')
  end
end
