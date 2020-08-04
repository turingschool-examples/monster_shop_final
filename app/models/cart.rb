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
#discount
  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      #change to be based off of sub total
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end
#discount
  def count_of(item_id)
    @contents[item_id.to_s]
  end
# discount
  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_eligible?(item_id)
    item = Item.find(item_id)
    item_count = count_of(item_id)
    item.discounts
    item.discounts.where("item_amount <= #{item_count}").first
  end
end
