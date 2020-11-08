require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :items_required}
    it {should validate_presence_of :discount}
  end
end
