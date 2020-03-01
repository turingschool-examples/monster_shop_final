class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :item_discounts
  has_many :items, through: :item_discounts
  
  def create_item_discounts(item_ids, amount, num_items)
    ids = item_ids.drop(1)
    ids.each do |id|
      item_discounts.create(item_id: id.to_i, amount: amount.to_i, num_items: num_items.to_i)
    end
  end
end
