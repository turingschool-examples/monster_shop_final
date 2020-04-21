require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_inclusion_of(:percentage)
          .in_range(1..99)
          .with_message("Percentage must be 1 - 99")}
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe 'instance methods' do
    it '.calculation_percentage' do
      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      discount_1 = Discount.create!(quantity: 5, percentage: 10, merchant_id: brian.id)
      expect(discount_1.calculation_percentage).to eq(0.9)
    end
  end
end