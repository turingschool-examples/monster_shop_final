require 'rails_helper'

RSpec.describe 'When I visit the discount show page' do
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

  it "I see a link that deletes this discount" do

    visit "/merchant/discounts/#{@discount.id}"

    click_link 'Delete Discount'

    expect(current_path).to eq('/merchant/discounts')

    save_and_open_page

    expect(page).to_not have_content("#{@discount.id}")
  end
end
