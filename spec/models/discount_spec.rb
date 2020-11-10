require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :description }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :percent }
    it { is_expected.to validate_inclusion_of(:enable).in_array([true, false]) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant)}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @megan_discount_1 = @megan.discounts.create!(description: "Buy 5 items, get 5% off ", quantity: 5, percent: 5)
      @megan_discount_3 = @megan.discounts.create!(description: "Buy 10 items, get 45% off ", quantity: 10, percent: 45, enable: false)
    end
    it '.enabled_status' do
      expect(@megan_discount_1.enabled_status).to eq('Enabled')
      expect(@megan_discount_3.enabled_status).to eq('Disabled')
    end
  end
end
