require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {has_many(:user_addresses)}
    it {should have_many(:users).through(:user_addresses)}
  end

  describe 'Validations' do
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end
end
