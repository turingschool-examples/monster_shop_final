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
      if available_discount?(item_id)
        grand_total += discounted_subtotal(item_id)
      else
        grand_total += Item.find(item_id).price * quantity
      end
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

  def maximum_discount(item_id)
    item = Item.find(item_id)
    quantity = count_of(item_id)
    item.merchant.discounts.where("item_amount <= ?", quantity).maximum(:discount_percentage)
  end

  def available_discount?(item_id)
    !maximum_discount(item_id).nil?
  end

  def discounted_subtotal(item_id)
    subtotal_of(item_id) * (1 - (maximum_discount(item_id) / 100.0))
  end

end
