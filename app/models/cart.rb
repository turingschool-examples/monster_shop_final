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
    subtotal = @contents[item_id.to_s] * Item.find(item_id).price * (1 - (merchant_discounts(item_id)/ 100))
  end

  def price_of(item_id)
    subtotal_of(item_id) / @contents[item_id.to_s]
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def merchant_discounts(item_id)
    item = Item.find(item_id)
    if Discount.where(merchant_id: item.merchant.id)
      applicable_discounts(item_id)
    else
      return 0
    end
  end

  def applicable_discounts(item_id)
    item = Item.find(item_id)
    discounts = Discount.where(merchant_id: item.merchant.id)
    eligable_discounts = discounts.where("quantity <= ?", @contents[item_id.to_s])
    if eligable_discounts.empty?
      return 0
    else  
      eligable_discounts.order(amount: :desc).first.amount
    end
  end
end
