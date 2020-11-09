module CartConcern
  extend ActiveSupport::Concern

  def find_merchant(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
  end

  def find_item(item_id)
    item = Item.find(item_id)
  end
end
