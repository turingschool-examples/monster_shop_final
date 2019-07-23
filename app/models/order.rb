class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def grand_total
    order_items.sum('price * quantity')
  end

  def count_of_items
    order_items.sum(:quantity)
  end
end
