class Cart
  attr_reader :contents, :saved_discounts, :current_discount

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
    @saved_discounts = 0.0

    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      merchant = Merchant.find(item.merchant_id)
      if !merchant.discounts.empty? && discount_criteria_met?(item, quantity)
        new_item_total = item.price * quantity
        grand_total += new_cart_discounts(@current_discount, new_item_total)
      else
        grand_total += item.price * quantity
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

  def show_discounts(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
    return_message = ""
    if merchant.discounts.empty?
      return_message = 'There are no discounts available at this moment'
    else
      merchant.discounts.order(:quantity).each do |discount|
        quantity = @contents[item.id.to_s] # this needs to be a string because the keys are strings
        if discount_criteria_met?(item, quantity)
          return_message = 'Wahoo! You qualify for a bulk discount!'
        else
          break return_message = discount.description
        end
      end
    end
    return_message
  end

  def discount_criteria_met?(item, quantity)
    merchant = Merchant.find(item.merchant_id)
    merchant.discounts.order(:quantity).each do |discount|
      if quantity >= discount.quantity
        all_available_discounts(item, quantity)
        return true
      else
        return false
      end
    end
  end

  def all_available_discounts(item, quantity)
    merchant = Merchant.find(item.merchant_id)
    discounted_totals = {}
    merchant.discounts.order(:quantity).each do |discount|
      if quantity >= discount.quantity
        percentage = (100 - discount.percent).to_f / 100
        new_total = item.price * quantity
        discount_total = new_total * percentage
        discounted_totals[discount.id] = new_total - discount_total
      end
    end
    @current_discount = Discount.find(discounted_totals.key(discounted_totals.values.max))
  end

  def new_cart_discounts(discount, sub_total)
    # binding.pry
    percentage = (100 - discount.percent).to_f / 100
    new_total = sub_total * percentage
    @saved_discounts += sub_total - new_total
    new_total
  end
end
