require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :percent }
    it {should validate_presence_of :quantity_required }
  end

  describe "relationships" do
    it {should belong_to :merchant }
  end
end
