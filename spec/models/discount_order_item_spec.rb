require 'rails_helper'

RSpec.describe DiscountOrderItem do
  describe 'relationships' do
    it {should belong_to :discount}
    it {should belong_to :order_item}
  end
end