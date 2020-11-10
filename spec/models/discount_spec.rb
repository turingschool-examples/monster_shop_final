require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :rate}
    it {should validate_presence_of :quantity}
    it {should validate_numericality_of(:rate).is_greater_than(0).is_less_than_or_equal_to(100)}
    it {should validate_numericality_of(:quantity).is_greater_than(0)}
  end
end
