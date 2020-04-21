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
end