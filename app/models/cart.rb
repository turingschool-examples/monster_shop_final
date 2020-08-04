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
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    if discount_eligible?(item_id).nil?
      @contents[item_id.to_s] * Item.find(item_id).price
    else
      discount = @contents[item_id.to_s] * Item.find(item_id).price * discount_eligible?(item_id).percentage.to_f / 100
      @contents[item_id.to_s] * Item.find(item_id).price - discount
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_eligible?(item_id)
    item = Item.find(item_id)
    item_count = count_of(item_id)
    ordered_discounts = item.discounts.order(:item_amount)
    ordered_discounts.where("item_amount <= #{item_count}").last
  end
end
