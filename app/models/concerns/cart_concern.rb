module CartConcern
  extend ActiveSupport::Concern

  def find_merchant(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
  end

  def find_item(item_id)
    item = Item.find(item_id)
  end

  def empty_merchant_discount?(item_id)
    !find_merchant(item_id).discounts.empty?
  end

  def percentage(discount)
    (100 - discount.percent).to_f / 100
  end
end
