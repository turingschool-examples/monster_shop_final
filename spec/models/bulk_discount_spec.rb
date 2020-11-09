require "rails_helper"

describe BulkDiscount do
  describe "validations" do
    it { should validate_numericality_of(:bulk_quantity).is_greater_than(0) }
    it { should validate_inclusion_of(:percentage_discount)
      .in_range(1..100)
      .with_message("Discount must be percentage from 1 - 100") }
  end

  describe "associations" do
    it { should belong_to :merchant }
  end
end
