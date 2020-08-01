require 'rails_helper'

RSpec.describe Discount do
  describe 'Validations' do
    it {should validate_presence_of :percent}
    it {should validate_presence_of :req_inventory}
  end

  describe 'Relationships' do
    it {should have_many(:merchants).through(:merchant_discounts)}
    it {should have_many :merchant_discounts}
  end
end
