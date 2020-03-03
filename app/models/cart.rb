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
      grand_total += (item.price - (item.price * item.discount_percentage(item.merchant_id, @contents[item_id.to_s])/100.to_f)) * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    merchant_id = item.merchant.id
    item.discount_percentage(merchant_id, @contents[item_id.to_s])
    @contents[item_id.to_s] * (item.price - (item.price * item.discount_percentage(item.merchant_id, @contents[item_id.to_s])/100.to_f))
  end


  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
