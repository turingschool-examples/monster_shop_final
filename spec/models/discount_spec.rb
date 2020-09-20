require "rails_helper"

RSpec.describe Discount do

  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_numericality_of(:item_amount).is_greater_than(0)}
    it {should validate_numericality_of(:discount_percentage)
        .in_range(1..99)
        .with_message("Discount percentage must be 1 - 99")}
  end

end
