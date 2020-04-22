require "rails_helper"

RSpec.describe "Bulk discount creation" do
  describe "As a Merchant user" do
    before :each do
      @merchant_1 = Merchant.create!(
        name: 'Megans Marmalades',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218)

      @merchant_user = @merchant_1.users.create(
        name: 'Megan',
        address: '123 Main St',
        city: 'Denver',
        state: 'CO',
        zip: 80218,
        email: 'megan@example.com',
        password: 'securepassword')
      @ogre = @merchant_1.items.create!(
        name: 'Ogre',
        description: "I'm an Ogre!",
        price: 20.25,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 5 )
      @giant = @merchant_1.items.create!(
        name: 'Giant',
        description: "I'm a Giant!",
        price: 50,
        image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw',
        active: true,
        inventory: 3 )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    context "when I visit the discount new page" do
      it "I see a form that I can fill out and submit to create a new merchant discount" do
        visit "/merchant/discounts/new"

        fill_in 'Name', with: "Jumbo size discount"
        fill_in 'Percent', with: "15"
        fill_in 'Threshold', with: "25"
        click_button 'Create Discount'

        expect(current_path).to eq("/merchant/discounts")

        expect(page).to have_content("Jumbo size discount")
        expect(page).to have_content("Percentage: 15%")
      end

      it "if I put in invalid information into the form, I get a flash message telling me what went wrong" do
        visit "/merchant/discounts/new"

        fill_in 'Percent', with: "300"
        fill_in 'Threshold', with: "yeet"
        click_button 'Create Discount'
        expect(current_path).to eq("/merchant/discounts")


        expect(page).to have_content("name: [\"can't be blank\"]")
        expect(page).to have_content("percent: [\"must be less than 100\"]")
        expect(page).to have_content("threshold: [\"is not a number\"]")
      end
    end
  end
end
