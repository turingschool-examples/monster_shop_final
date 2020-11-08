require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard' do
    before :each do
    @merchant1 = create(:merchant)
    @merchant1.users << @merchant_admin
    page.set_rack_session(user_id: @merchant_admin.id)
  end
    describe 'when i am on the index page' do
      it 'I see a link to create a new discount' do
        visit '/merchant/discounts'
        expect(page).to have_link("Create New Discount")
      end

      it 'when I click the link create new discount' do
        visit '/merchant/discounts'
        click_link("Create New Discount")
        expect(current_path).to eq('/merchant/discounts/new')
        expect(page).to have_field('name')
        expect(page).to have_field('percent')
        expect(page).to have_field('quantity_req')
      end
    end
    describe 'when I fill in the form data and click the submit button' do
      it 'I am brought back to the index page where i can see the new discount showing' do
        visit '/merchant/discounts/new'
        fill_in :name, with: 'Super Discount'
        fill_in :items_req, with: 5
        fill_in :discount, with: 10
        click_button 'Create Discount'
        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('Super Discount')
        expect(page).to have_content('10.0%')
        expect(page).to have_content('Applies when 5 or more items are ordered')
      end
    end
  end
end





    end
  end
end
