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
    @contents.sum do |item_id, _|
      subtotal_of(item_id)
    end
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * discount_price(item_id)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_price(item_id)
    item = Item.find(item_id)
    percent_off = item.merchant.discounts.where("minimum_quantity <= ?", @contents[item_id.to_s]).maximum(:percent_off)
    if percent_off
      item.price * (100 - percent_off)/100.0
    else
      item.price
    end
  end

  def calculate_discount(item_id)
    item = Item.find(item_id)
    @contents[item_id.to_s] * (item.price - discount_price(item_id))
  end
end
