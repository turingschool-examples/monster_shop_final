require 'rails_helper'

RSpec.describe 'When I visit the discount edit page' do
  before :each do
    @merchant = Merchant.create!(name: 'Megans Marmalades',
                                  address: '123 Main St',
                                  city: 'Denver',
                                  state: 'CO',
                                  zip: 80218)

    @employee = @merchant.users.create(name: 'Johnny',
                                              address: '12333 Grape St',
                                              city: 'Denver',
                                              state: 'CO',
                                              zip: 802221,
                                              email: 'employee@example.com',
                                              password: 'securepassword')

    @discount = Discount.create(percentage: 15,
                                     bulk: 10,
                                     merchant_id: @merchant.id)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
  end

  it 'I can fill out a form to edit that bulk discount' do

    visit "/merchant/discounts/#{@discount.id}/edit"

    fill_in 'Percentage', with: 10
    fill_in 'Bulk', with: 20

    click_button 'Update Discount'

    expect(current_path).to eq('/merchant/discounts')

    within "#discount-#{@discount.id}" do
      expect(page).to have_content(10)
      expect(page).to have_content(20)
    end
  end
end
