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
    discounts = Discount.where(item_id: item_id)
    discount = discounts.first
    full_price = @contents[item_id.to_s] * Item.find(item_id).price
    if discount && @contents[item_id.to_s] >= discount.minimum_quantity
      discount_price(full_price, discount.percentage)
    else
      full_price
    end
  end

  def discount_price(full_price, percentage_off)
    full_price - (full_price * (percentage_off.to_f/100))
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
