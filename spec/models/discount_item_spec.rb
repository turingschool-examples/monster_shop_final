require 'rails_helper'

RSpec.describe DiscountItem do
  describe 'relationships' do
    it {should belong_to :discount}
    it {should belong_to :item}
  end
end