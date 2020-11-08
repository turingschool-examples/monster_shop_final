class Cart
  attr_reader :contents, :saved_discounts, :current_discount

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def find_merchant(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
  end

  def find_item(item_id)
    item = Item.find(item_id)
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
      find_item(item_id)
    end
  end

  def empty_merchant_discount?(item_id)
    !find_merchant(item_id).discounts.empty?
  end

  def grand_total
    grand_total = 0.0
    @saved_discounts = 0.0

    @contents.each do |item_id, quantity|
      if empty_merchant_discount?(item_id) && discount_criteria_met?(find_item(item_id), quantity)
        new_item_total = find_item(item_id).price * quantity
        grand_total += new_cart_discounts(@current_discount, new_item_total)
      else
        grand_total += find_item(item_id).price * quantity
      end
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * find_item(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == find_item(item_id).inventory
  end

  def show_discounts(item_id)
    return_message = ""
    if find_merchant(item_id).discounts.empty?
      return_message = 'There are no discounts available at this moment'
    else
      find_merchant(item_id).discounts.order(:quantity).each do |discount|
        quantity = @contents[find_item(item_id).id.to_s] # this needs to be a string because the keys are strings
        if discount_criteria_met?(find_item(item_id), quantity)
          return_message = 'Wahoo! You qualify for a bulk discount!'
        else
          break return_message = discount.description
        end
      end
    end
    return_message
  end

  def discount_criteria_met?(item, quantity)
    find_merchant(item.id).discounts.order(:quantity).each do |discount|
      if quantity >= discount.quantity
        all_available_discounts(item, quantity)
        return true
      else
        return false
      end
    end
  end

  def percentage(discount)
    (100 - discount.percent).to_f / 100
  end

  def all_available_discounts(item, quantity)
    discounted_totals = {}
    find_merchant(item.id).discounts.order(:quantity).each do |discount|
      if quantity >= discount.quantity
        percentage(discount)
        new_total = item.price * quantity
        discount_total = new_total * percentage(discount)
        discounted_totals[discount.id] = new_total - discount_total
      end
    end
    @current_discount = Discount.find(discounted_totals.key(discounted_totals.values.max))
  end


  def new_cart_discounts(discount, sub_total)
    percentage(discount)
    new_total = sub_total * percentage(discount)
    @saved_discounts += sub_total - new_total
    new_total
  end
end
