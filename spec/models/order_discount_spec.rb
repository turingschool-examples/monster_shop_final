require 'rails_helper'

RSpec.describe OrderDiscount do
  describe 'relationships' do
    it {should belong_to :order}
    it {should belong_to :discount}
  end
end
