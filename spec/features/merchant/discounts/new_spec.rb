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
        expect(page).to have_field('discount[name]')
        expect(page).to have_field('discount[discount]')
        expect(page).to have_field('discount[items_required]')
      end
    end

    describe 'when I fill in the form data and click the submit button' do
      it 'I am brought back to the index page where i can see the new discount showing' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: 10
        click_button 'Create Discount'
        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('Super Discount')
        expect(page).to have_content('5.0%')
        expect(page).to have_content('Applies when 10 or more items are ordered')
      end
    end

    describe 'when I fill in the form data with incorrect data or missing' do
      it 'no name' do
        visit '/merchant/discounts/new'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: 10
        click_button 'Create Discount'
        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('Discount')
        expect(page).to have_content('5.0%')
        expect(page).to have_content('Applies when 10 or more items are ordered')
      end

      it 'no items_required' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5
        expect(page).to have_field 'discount[items_required]', with: ''
        expect(page).to have_content("Items required can't be blank and Items required is not a number")
      end

      it 'no discount' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[items_required]', with: 10
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: ''
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount can't be blank and Discount is not a number")
      end

      it 'discount less than 0' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: -5
        fill_in 'discount[items_required]', with: 10
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: -5
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount must be greater than 0")
      end

      it 'discount is a string' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 'a'
        fill_in 'discount[items_required]', with: 10
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 'a'
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount is not a number")
      end

      it 'items require is less than 0' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: -10
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5
        expect(page).to have_field 'discount[items_required]', with: -10
        expect(page).to have_content("Items required must be greater than 0")
      end

      it 'items require is a string' do
        visit '/merchant/discounts/new'
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: 'a'
        click_button 'Create Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5
        expect(page).to have_field 'discount[items_required]', with: 'a'
        expect(page).to have_content("Items required is not a number")
      end

    end
  end
end
