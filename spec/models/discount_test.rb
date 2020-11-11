require 'rails_helper'

class DiscountTest < ActiveSupport::TestCase
  describe 'Relationships' do
    it {should belong_to :merchant}
  end 

  describe 'Validations' do
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :item_requirement}
  end 

  describe 'Instance Methods' do
    it '.percentage_display' do 
      merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      discount1 = merchant_1.discounts.create!(percent_off: 0.10, item_requirement: 5)
      
      expect(discount1.percentage_display).to eq(10)
    end
  end
end 
