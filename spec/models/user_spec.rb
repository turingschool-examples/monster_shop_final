require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
    it {has_many(:user_addresses)}
    it {has_many(:addreses, through: :user_addresses)}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    # it {should validate_presence_of :address}
    # it {should validate_presence_of :city}
    # it {should validate_presence_of :state}
    # it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
  end
end
