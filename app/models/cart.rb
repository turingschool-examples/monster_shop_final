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
    @contents.each do |item_id, _|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    if it_discounted(item_id)
      (@contents[item_id.to_s] * Item.find(item_id).price) -  (@contents[item_id.to_s] * Item.find(item_id).price) * highest_disc(item_id)
    else
      @contents[item_id.to_s] * Item.find(item_id).price
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def it_discounted(item_id)
    Item.find(item_id).merchant.discounts.each do |discount|
      return true if can_discount?(item_id, discount)
    end
    return false
  end

  def can_discount?(item_id, discount)
    count_of(item_id) >= discount.min_quantity
  end

  def highest_disc(item_id)
    Item.find(item_id).merchant.discounts.where("min_quantity <= ?", @contents[item_id.to_s]).maximum(:percent_off).to_f / 100.00
  end
end
