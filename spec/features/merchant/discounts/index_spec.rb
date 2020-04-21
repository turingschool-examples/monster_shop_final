require 'rails_helper'

RSpec.describe 'As a merchant user' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades',
                                  address: '123 Main St',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80218)
    @merchant_user = @merchant1.users.create(name: 'Megan',
                                              address: '123 Main St',
                                              city: 'Denver',
                                              state: 'CO',
                                              zip: 80218,
                                              email: 'megan@example.com',
                                              password: 'securepassword')
    @discount1 = Discount.create(percentage: 5,
                                     bulk: 20,
                                     merchant_id: @merchant1.id)
    @discount2 = Discount.create(percentage: 10,
                                     bulk: 30,
                                     merchant_id: @merchant1.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end

  describe 'When I visit /merchant/bulk_discounts'
    it 'I can see all availablediscounts' do

    visit '/merchant/discounts'

    expect(page).to have_content("Available Discounts")
    expect(page).to have_link("Create New Discount")

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_content(@discount1.bulk)
    end
  end
end
