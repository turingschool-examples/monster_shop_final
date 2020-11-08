require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard' do
    before :each do
    @merchant1 = create(:merchant)
    @merchant1.users << @merchant_admin
    page.set_rack_session(user_id: @merchant_admin.id)
  end
    describe 'I see on the page a link to discounts' do
      it 'I click this link and I end up on discounts index' do
        visit '/merchant'
        expect(page).to have_link('My Discounts')
        click_link('My Discounts')
        expect(current_path).to eq('/merchant/discounts')
      end
    end
    describe 'when i am on the index page' do
      it 'i see a list of all my discounts' do
        @merchant2 = create(:merchant)

        discount1 = @merchant1.discounts.create!(name: 'Super Sale 3',
                                                 items_required: 15,
                                                 discount: 20)
        discount2 = @merchant1.discounts.create!(name: 'Super Sale 1',
                                                 items_required: 10,
                                                 discount: 15)
        discount3 = @merchant1.discounts.create!(name: 'Super Sale 2',
                                                 items_required: 20,
                                                 discount: 30)
        discount4 = @merchant2.discounts.create!(name: 'Super Sale 2',
                                                 items_required: 20,
                                                 discount: 30)
        visit '/merchant/discounts'
        within("#discount-#{discount1.id}") do
          expect(page).to have_content('Super Sale 3')
          expect(page).to have_content('Applies when 15 or more items are ordered')
          expect(page).to have_content('20.0%')
        end

        within("#discount-#{discount2.id}") do
          expect(page).to have_content('Super Sale 1')
          expect(page).to have_content('Applies when 10 or more items are ordered')
          expect(page).to have_content('15.0%')
        end

        within("#discount-#{discount3.id}") do
          expect(page).to have_content('Super Sale 2')
          expect(page).to have_content('Applies when 20 or more items are ordered')
          expect(page).to have_content('30.0%')
        end

        expect(page).to_not have_css("discount-#{discount4.id}")
      end
    end
  end
end
