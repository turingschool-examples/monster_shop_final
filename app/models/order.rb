class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def grand_total
    order_items.sum('price * quantity')
  end

  def grand_discount
    #iteration 3,492
    # order_discounts = order_items
    #                       .joins(:discounts)
    #                       .select("items.id, items.price, order_items.quantity, max(discount) as max_discount")
    #                       .where("order_items.quantity >= discounts.threshold")
    #                       .group("items.id, items.price, order_items.quantity")
    #                       .pluck("items.price * order_items.quantity * max(discount)")
    #iteration 3,493
    # order_discounts = order_items
    #                       .joins(:discounts)
    #                       .select("items.id, items.price, order_items.quantity")
    #                       .where("order_items.quantity >= discounts.threshold")
    #                       .group("items.id, items.price, order_items.quantity")
    #                       .pluck("items.price * order_items.quantity * max(discount)")
    
    #iteration 3,494
    # order_discounts = order_items
    #                       .joins(:discounts)
    #                       .where("order_items.quantity >= discounts.threshold")
    #                       .group("items.id, items.price, order_items.quantity")
    #                       .pluck("items.price * order_items.quantity * max(discount)")
    
    #iteration 3,495
    order_items
        .joins(:discounts)
        .where("order_items.quantity >= discounts.threshold")
        .group("items.id, items.price, order_items.quantity")
        .pluck("items.price * order_items.quantity * max(discount)")
        .sum
  end

  def count_of_items
    order_items.sum(:quantity)
  end

  def cancel
    update(status: 'cancelled')
    order_items.each do |order_item|
      order_item.update(fulfilled: false)
      order_item.item.update(inventory: order_item.item.inventory + order_item.quantity)
    end
  end

  def merchant_subtotal(merchant_id)
    order_items
      .joins("JOIN items ON order_items.item_id = items.id")
      .where("items.merchant_id = #{merchant_id}")
      .sum('order_items.price * order_items.quantity')
  end

  def merchant_quantity(merchant_id)
    order_items
      .joins("JOIN items ON order_items.item_id = items.id")
      .where("items.merchant_id = #{merchant_id}")
      .sum('order_items.quantity')
  end

  def is_packaged?
    update(status: 1) if order_items.distinct.pluck(:fulfilled) == [true]
  end

  def self.by_status
    order(:status)
  end
end
