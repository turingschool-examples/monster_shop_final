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

  def blended_price(item_id)
    (subtotal_of(item_id) / count_of(item_id)).round(2)
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    if applicable_discount(item_id).nil? || @contents[item_id.to_s] < applicable_discount(item_id).quantity
      @contents[item_id.to_s] * Item.find(item_id).price
    else
      discounted_subtotal_of(item_id)
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def applicable_discount(item_id)
    count = count_of(item_id)
    Item.find(item_id).discount.where("#{count} >= quantity").order('percent DESC').limit(1).first
  end

  def discounted_subtotal_of(item_id)
    percent = 1 - (applicable_discount(item_id).percent.to_f / 100)
    discounted_price = Item.find(item_id).price * percent
    count_of(item_id) * discounted_price.round(2)
  end

  def savings(item_id)
    (@contents[item_id.to_s] * Item.find(item_id).price) - discounted_subtotal_of(item_id)
  end
end
