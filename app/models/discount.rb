class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :order_items, through: :items
  has_many :orders, through: :order_items

  validates_presence_of :percent_off,
                        :quantity_threshold,
                        :status

  enum status: ['active', 'inactive']

  def has_not_been_used(id)
    OrderItem.where(discount_id: id) == []
  end




end
