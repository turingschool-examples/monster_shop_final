require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'Validations' do
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :nickname}
  end

  describe 'Instance Methods' do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword', role: 2)
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'work')
      @address_3 = @user.addresses.create!(street_address: '456 Main st', city: 'Reno', state: 'NV', zip: 75443, nickname: 'gf house')

    end

    it '.default_nickname' do
       expect(@address_1.nickname).to eq('Home')
    end

    it '.normalize_nickname' do
      expect(@address_2.nickname).to eq('Work')
      expect(@address_3.nickname).to eq('Gf House')
    end

    it '.assign_default_address' do
      expect(@user.default_address).to eq(@address_1.id)
    end
  end
end
