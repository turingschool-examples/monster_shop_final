require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should have_many(:merchants).through(:merchant_discounts)}
    it {should have_many :merchant_discounts}
  end
end
