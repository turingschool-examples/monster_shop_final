class Discount < ApplicationRecord
  belongs_to :item
  belongs_to :merchant

  validates_presence_of :item_id
  validates_presence_of :merchant_id
  validates_presence_of :threshold
  validates_numericality_of :threshold, greater_than: 0
  validates_presence_of :discount
  validates_numericality_of :discount, greater_than: 0
  validates_numericality_of :discount, less_than: 1

  def self.item_discount(item,order_quantity)
    discount = Discount
                  .where(item_id: item.id, merchant_id: item.merchant.id)
                  .where("discounts.threshold <= ?",order_quantity)
                  .order(discount: :desc)
                  .limit(1).first

    discount.nil? ? nil : discount.discount * order_quantity * item.price
  end

end
