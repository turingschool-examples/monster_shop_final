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

#  def bulk_discount?
#    limits = []
#    @contents.each do |item_id, quantity|
#      item = Item.find(item_id)
#      limits << item.merchant.discounts.pluck(:limit)
#    end
#    limits.empty? == false
#  end

  def grand_total
    grand_total = 0.0
    @contents.each { |item_id, quantity| grand_total += subtotal_of(item_id)}
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    subtotal = 0.0
    savings = 0.0
    item = Item.find(item_id)
    quantity = @contents[item.id.to_s]
    discount = item.available_discounts.discount_rate(quantity)
    (savings += ((item.price * quantity) * discount[:percentage])) if discount != nil
    (subtotal += (item.price * quantity) - savings)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
