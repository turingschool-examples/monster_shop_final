class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def full_address
    "#{self.address}, #{self.city}, #{self.state}, #{self.zip}"
  end

  def find_item(item_id)
    item = Item.find(item_id)
  end

  def find_merchant(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
  end

  def find_all_discounts(item_id)
    find_merchant(item_id).discounts.order(:quantity)
  end

  def percentage(discount)
    ((100 - discount.percent).to_f / 100)
  end

  def empty_merchant_discount?(item_id)
    !find_merchant(item_id).discounts.empty?
  end

  def all_available_discounts(item, quantity)
    discounted_totals = Hash.new
    find_all_discounts(item.id).each do |discount|
      if quantity >= discount.quantity
        percentage(discount)
        new_total = item.price * quantity
        discount_total = new_total * percentage(discount)
        discounted_totals[discount.id] = new_total - discount_total
        # binding.pry
      end
    end
    # binding.pry
    discount = Discount.find(discounted_totals.key(discounted_totals.values.max))
    @current_discount = discount
  end

  def discount_criteria_met?(item, quantity)
    find_all_discounts(item.id).each do |discount|
      if quantity >= discount.quantity
        all_available_discounts(item, quantity)
        return true
      else
        return false
      end
    end
  end
end
