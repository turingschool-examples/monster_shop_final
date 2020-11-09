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

  def all_available_discounts(item, quantity)
    discounted_totals = {}
    find_merchant(item.id).discounts.order(:quantity).each do |discount|
      if quantity >= discount.quantity
        percentage(discount)
        new_total = item.price * quantity
        discount_total = new_total * percentage(discount)
        discounted_totals[discount.id] = new_total - discount_total
      end
    end
    @current_discount = Discount.find(discounted_totals.key(discounted_totals.values.max))
  end
end
