require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
    it {should have_many :addresses}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
  end

  describe 'Instance Methods' do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword', role: 2)
      @address_1 = @user.addresses.create!(street_address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address_2 = @user.addresses.create!(street_address: '456 Main st', city: 'Dallas', state: 'TX', zip: 75402, nickname: 'Work')
    end

    it '.my_address' do
      expect(@user.my_address).to eq(@address_1)
    end

    it '.assign_address' do
      expect(@user.default_address).to eq(@address_1.id)
      @user.assign_address(@address_2.id)
      expect(@user.default_address).to eq(@address_2.id)
    end

    it '.nickname_uniq?' do
      expect(@user.nickname_uniq?('Home')).to eq(false)
      expect(@user.nickname_uniq?('Work')).to eq(false)
      expect(@user.nickname_uniq?('gf')).to eq(true)
    end
  end
end
