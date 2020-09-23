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
      item = Item.find(item_id)
      grand_total += sale_price(item) * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    @contents[item_id.to_s] * sale_price(item)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item)
    item.merchant.discounts
    .where("? >= threshold_quantity", count_of(item.id))
    .order(:discount_percentage)
    .pluck(:discount_percentage)
    .last
  end

  def sale_price(item)
    if apply_discount(item)
      item.price * (100 - apply_discount(item))*0.01
    else
      item.price
    end
  end

end
