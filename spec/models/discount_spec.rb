require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :percentage}
    it {should validate_presence_of :item_amount}
    it {should validate_presence_of :description}
  end
end
