require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard' do
    before :each do
    @merchant1 = create(:merchant)
    @merchant1.users << @merchant_admin
    page.set_rack_session(user_id: @merchant_admin.id)

    @discount1 = @merchant1.discounts.create!(name: 'Super Sale 3',
                                             items_required: 15,
                                             discount: 20)
    @discount2 = @merchant1.discounts.create!(name: 'Super Sale 1',
                                             items_required: 10,
                                             discount: 15)
    @discount3 = @merchant1.discounts.create!(name: 'Super Sale 2',
                                             items_required: 20,
                                             discount: 30)
  end
    describe 'when i am on the index page' do
      it 'I see a link next to each discount to update' do
        visit '/merchant/discounts'

        within("#discount-#{@discount1.id}") do
          expect(page).to have_link('Update Discount')
        end

        within("#discount-#{@discount2.id}") do
          expect(page).to have_link('Update Discount')
        end

        within("#discount-#{@discount3.id}") do
          expect(page).to have_link('Update Discount')
        end
      end

      it 'when I click the link update discount i see a form with current information' do
        visit '/merchant/discounts'
        within("#discount-#{@discount1.id}") do
          click_link('Update Discount')
        end
        expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
        expect(page).to have_field 'discount[name]', with: 'Super Sale 3'
        expect(page).to have_field 'discount[discount]', with: 20.0
        expect(page).to have_field 'discount[items_required]', with: 15
      end
    end

    describe 'when I fill in the form data and click the submit button' do
      it 'I am brought back to the index page where i can see the new discount showing' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5.0
        fill_in 'discount[items_required]', with: 10
        click_button 'Update Discount'
        expect(current_path).to eq('/merchant/discounts')
        within("#discount-#{@discount1.id}") do
          expect(page).to have_content('Super Discount')
          expect(page).to have_content('5.0%')
          expect(page).to have_content('Applies when 10 or more items are ordered')
        end
      end
    end

    describe 'when I fill in the form data with incorrect data or missing' do
      it 'no name' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[discount]', with: 5.0
        fill_in 'discount[items_required]', with: 10
        click_button 'Update Discount'
        expect(current_path).to eq('/merchant/discounts')
        expect(page).to have_content('Discount')
        expect(page).to have_content('5.0%')
        expect(page).to have_content('Applies when 10 or more items are ordered')
      end

      it 'no items_required' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5.0
        fill_in 'discount[items_required]', with: ''
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5.0
        expect(page).to have_field 'discount[items_required]', with: ''
        expect(page).to have_content("Items required can't be blank and Items required is not a number")
      end

      it 'no discount' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[items_required]', with: 10
        fill_in 'discount[discount]', with: ''
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: ''
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount can't be blank and Discount is not a number")
      end

      it 'discount less than 0' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: -5
        fill_in 'discount[items_required]', with: 10
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: -5
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount must be greater than 0")
      end

      it 'discount is a string' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 'a'
        fill_in 'discount[items_required]', with: 10
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 'a'
        expect(page).to have_field 'discount[items_required]', with: 10
        expect(page).to have_content("Discount is not a number")
      end

      it 'items require is less than 0' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: -10
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5
        expect(page).to have_field 'discount[items_required]', with: -10
        expect(page).to have_content("Items required must be greater than 0")
      end

      it 'items require is a string' do
        visit "/merchant/discounts/#{@discount1.id}/edit"
        fill_in 'discount[name]', with: 'Super Discount'
        fill_in 'discount[discount]', with: 5
        fill_in 'discount[items_required]', with: 'a'
        click_button 'Update Discount'
        expect(page).to have_field 'discount[name]', with: 'Super Discount'
        expect(page).to have_field 'discount[discount]', with: 5
        expect(page).to have_field 'discount[items_required]', with: 'a'
        expect(page).to have_content("Items required is not a number")
      end

    end
  end
end
