require 'rails_helper'

RSpec.describe MerchantDiscount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should belong_to :discount}
  end
end
