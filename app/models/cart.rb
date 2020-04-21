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

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def grand_total
    @contents.sum do |item_id, _|
      subtotal(item_id)
    end
  end

  def subtotal(item_id)
    item = Item.find(item_id)
    quantity = @contents[item.id.to_s]
    quantity * item.price * (1 - discount_rate(item))
  end

  def discount_rate(item)
    percent_off = item.merchant.discounts.where("minimum_quantity <= ?", @contents[item.id.to_s]).maximum(:percent_off)
    percent_off = 0 if percent_off.nil?
    percent_off / 100.0
  end

  def bulk_discount(item)
    quantity = @contents[item.id.to_s]
    quantity * item.price * discount_rate(item)
  end
end
