class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end
  
  def subtotal_of(item_id)
    item_price = apply_discount(item_id)
    @contents[item_id.to_s] * item_price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item_id)
    item = Item.find(item_id)
    discount = find_discounts(item_id)
    if discount.any? && @contents[item_id.to_s] >= discount.first.quantity
      item.price * discount.first.calculation_percentage
    else
      item.price
    end
  end

  def find_discounts(item_id)
    item = Item.find(item_id)
    merchant_id = item.merchant_id
    Discount.where(merchant_id: merchant_id)
  end
end
