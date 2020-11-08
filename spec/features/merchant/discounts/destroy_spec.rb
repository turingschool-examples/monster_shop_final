require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant1.users << @merchant_admin
      page.set_rack_session(user_id: @merchant_admin.id)
      @merchant2 = create(:merchant)

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
      it 'i see a link to delete next to each discount shown on the page' do
        visit '/merchant/discounts'

        within("#discount-#{@discount1.id}") do
          expect(page).to have_link('Delete Discount')
        end

        within("#discount-#{@discount2.id}") do
          expect(page).to have_link('Delete Discount')
        end

        within("#discount-#{@discount3.id}") do
          expect(page).to have_link('Delete Discount')
        end
      end
      it 'I click the delete link and I still on the index page but the discount is no longer there' do
        visit '/merchant/discounts'
        within("#discount-#{@discount1.id}") do
          click_link('Delete Discount')
        end
        expect(current_path).to eq('/merchant/discounts')
        expect(page).to_not have_css("#discount-#{@discount1.id}")
        expect(page).to_not have_content('Super Sale 3')
        expect(page).to_not have_content('Applies when 15 or more items are ordered')
        expect(page).to_not have_content('20.0%')
      end
    end
  end
end
