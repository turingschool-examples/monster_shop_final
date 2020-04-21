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
    item_price = apply_discount(item_id)
    @contents[item_id.to_s] * item_price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item_id)
    item = Item.find(item_id)
    discount = find_best_discount(item_id)
    if !discount.nil?
      item.price * ((100 - discount) * 0.01)
    else
      item.price
    end
  end

  def find_best_discount(item_id)
    item = Item.find(item_id)
    merchant_id = item.merchant_id
    Discount.where(merchant_id: merchant_id)
            .where("quantity <= ?", @contents[item_id.to_s])
            .maximum(:percentage)
  end
end
