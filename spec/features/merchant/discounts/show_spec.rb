require 'rails_helper'

RSpec.describe 'Merchant Discount Show Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create(percent: 5, quantity: 10)
      @discount_2 = @merchant_1.discounts.create(percent: 10, quantity: 20)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I see all the information about the discount and a link back to the index page" do
      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount: #{@discount_1.id}")
      expect(page).to have_content("Percent Off: #{@discount_1.percent}")
      expect(page).to have_content("Required Item Quantity: #{@discount_1.quantity} units")
      expect(page).to have_link("Deactivate")

      click_on "Back to All Bulk Discounts"
      expect(current_path).to eq('/merchant/discounts')

      @discount_1.update(status: 1)

      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_link("Delete")
      expect(page).to have_link("Activate")
    end
  end
end
