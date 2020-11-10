class Discount < ApplicationRecord
  belongs_to :item

  validates_presence_of :item_id
  validates_presence_of :threshold
  validates_numericality_of :threshold, greater_than: 0
  validates_presence_of :discount
  validates_numericality_of :discount, greater_than: 0
  validates_numericality_of :discount, less_than: 1

  def self.item_discount(item_id, item_price, order_quantity)
    discount = Discount
                  .where(item_id: item_id)
                  .where("discounts.threshold <= ?",order_quantity)
                  .order(discount: :desc)
                  .limit(1).first

    discount.nil? ? 0 : discount.discount * order_quantity * item_price
  end

end
