require 'rails_helper'

RSpec.describe MerchantDiscount do
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should belong_to :discount}
  end
end 