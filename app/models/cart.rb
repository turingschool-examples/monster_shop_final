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

  def bulk_discount?
    limits = []
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      limits << item.merchant.discounts.pluck(:limit)
    end
    limits.empty? == false
  end

  def grand_total
    savings = 0.0
    grand_total = 0.0
    if bulk_discount?
      @contents.each do |item_id, quantity|
        item = Item.find(item_id)
        discount = item.merchant.discounts.where("discounts.limit <= ?", quantity).order(limit: :desc).first
        (savings += ((item.price * quantity) * discount[:percentage])) if discount != nil
        grand_total += (item.price * quantity)
      end
    end
    grand_total - savings
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
end
