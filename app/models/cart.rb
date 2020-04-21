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
      grand_total += Item.find(item_id).price * quantity
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

  # def active_discount(item_id)
  #   discounts = available_discounts(item_id).select do |discount|
  #     count_of(item_id) >= discount.bulk
  # end
  #   if discounts.empty?
  #     discounts.max_by(&:percentage).percentage
  #   end
  # end

  def active_discount(item_id)
    discounts = available_discounts(item_id).select do |discount|
      count_of(item_id) >= discount.bulk
    end
    if !discounts.empty?
      discounts.max_by(&:percentage).percentage
    end
  end

  def discount?(item_id)
    active_discount(item_id).present?
  end

  private

  def available_discounts(item_id)
    Item.find(item_id).merchant.discounts
  end
end
