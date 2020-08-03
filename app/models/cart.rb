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
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discounted_subtotal_of(item_id)
    item = Item.find(item_id)
    total_items_purchased = count_of(item_id)
    discounted_item_quantity = item.discount.quantity
    items_at_full_price = total_items_purchased - discounted_item_quantity
    discount = item.discount.percent.to_f / 100
    full_price = item.price
    discounted_price = full_price - (full_price * discount)
    cost_full_price_items = full_price * items_at_full_price
    cost_discounted_items = discounted_price * discounted_item_quantity
    cost_full_price_items + cost_discounted_items
  end
end
