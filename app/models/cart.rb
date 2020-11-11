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
      if item.discount_eligible(quantity)
        grand_total += discounted_subtotal_of(item_id)
      else
        grand_total += subtotal_of(item_id)
      end
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    count_of(item_id) * item.price
  end

  def discounted_subtotal_of(item_id)
    item = Item.find(item_id)
    (count_of(item_id) * item.price) - discount_amount(item)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_amount(item)
    (count_of(item.id) * item.price) * (item.discount_eligible(count_of(item.id)).rate / 100)
  end
end
