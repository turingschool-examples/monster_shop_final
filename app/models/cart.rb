class Cart
  attr_reader :contents
  
  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item)
    @contents[item] += 1
  end

  def total
    @contents.values.sum
  end
end
