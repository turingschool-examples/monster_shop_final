require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard' do
    before :each do
    @merchant1 = create(:merchant)
    @merchant1.users << @merchant_admin
    page.set_rack_session(user_id: @merchant_admin.id)
    @customer1 = create(:user)
    @customer2 = create(:user)
    @order1 = create(:order, user_id: @customer1.id)
    @order2 = create(:order, user_id: @customer2.id, status: "shipped")
    @order3 = create(:order, user_id: @customer2.id)
    @item1 = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant1.id)
    create(:order_item, order_id: @order1.id, item_id: @item1.id)
    create(:order_item, order_id: @order1.id, item_id: @item3.id)
    create(:order_item, order_id: @order2.id, item_id: @item2.id)
    create(:order_item, order_id: @order3.id, item_id: @item1.id)
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
        @discount1 = @merchant1.discounts.create!(name: 'Super Sale 3',
                                                 items_req: 15,
                                                 discount: 20)
        @discount2 = @merchant1.discounts.create!(name: 'Super Sale 1',
                                                 items_req: 10,
                                                 discount: 15)
        @discount3 = @merchant1.discounts.create!(name: 'Super Sale 2',
                                                 items_req: 20,
                                                 discount: 30)
        visit '/merchant/discounts'
        expext(page).to have_content('Super Sale 1')
        expext(page).to have_content('applies when 10 or more items are ordered')
        expext(page).to have_content('15%')
        expext(page).to have_content('Super Sale 3')
        expext(page).to have_content('applies when 15 or more items are ordered')
        expext(page).to have_content('20%')
        expext(page).to have_content('Super Sale 2')
        expext(page).to have_content('applies when 20 or more items are ordered')
        expext(page).to have_content('30%')
      end
      it 'I see a link to create a new discount' do
        visit '/merchant/discounts'

      end
    end
  end
end
