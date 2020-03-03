require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'Validations' do
    it {should validate_presence_of :title}
    it {should validate_presence_of :percent_off}
    it {should validate_presence_of :information}
    it {should validate_presence_of :lowest_amount}
    it {should validate_presence_of :highest_amount}
  end

  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Methods' do
    before(:each) do
      @bike_shop = Merchant.create!(name: 'Matts Bikes',
                                      address: '123 High St',
                                      city: 'Denver',
                                      state: 'CO',
                                      zip: 80210,
                                      enabled: true)
     @mike = @bike_shop.users.create!(name: "Mike",
                                      address: "124 Vine St",
                                      city: "Denver",
                                      state: "CO",
                                      zip: "80206",
                                      email: "mike@gmail.com",
                                      password: "mike",
                                      role: 2)

      @discount1 = @bike_shop.discounts.create!(title: "Bulk Discount",
                                                percent_off: 5,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 5,
                                                highest_amount: 9)
      @discount2 = @bike_shop.discounts.create!(title: "huge Discount",
                                                percent_off: 20,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 10,
                                                highest_amount: 19)
      @discount3 = @bike_shop.discounts.create!(title: "Giant Discount",
                                                percent_off: 25,
                                                information: "Thanks for buying in bulk",
                                                lowest_amount: 20,
                                                highest_amount: 29)
      end
    it "can dispaly discount_range" do
      expect(@discount1.discount_range).to eq("5 - 9 items")
    end

  end
end
