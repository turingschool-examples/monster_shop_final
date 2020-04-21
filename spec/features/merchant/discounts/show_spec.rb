require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  before :each do
    @merchant = Merchant.create!(name: 'Megans Marmalades',
                                  address: '123 Main St',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80218)
    @employee = @merchant.users.create(name: 'Megan',
                                              address: '123 Main St',
                                              city: 'Denver',
                                              state: 'CO',
                                              zip: 80218,
                                              email: 'megan@example.com',
                                              password: 'securepassword')
    @discount = Discount.create(percentage: 10,
                                     bulk: 15,
                                     merchant_id: @merchant.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)

    visit '/merchant/discounts'
  end

describe 'When I am on the merchant discounts page'

  it "I see a link that takes me to that discounts show page and lists discount attributes" do

    within "#discount-#{@discount.id}" do
      click_link "10% discount if you buy at least 15 items"
    end

    expect(current_path).to eq("/merchant/discounts/#{@discount.id}")
    expect(page).to have_content("Discount Number: #{@discount.id}")
  end
end
