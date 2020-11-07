require 'rails_helper'
feature 'As a Merchant' do
  given!(:user) {@merchant_admin = create(:user, role: 1)}
  describe 'I visit my dashboard and see a link to discounts'
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
    create(:item_order, order_id: @order1.id, item_id: @item1.id)
    create(:item_order, order_id: @order1.id, item_id: @item3.id)
    create(:item_order, order_id: @order2.id, item_id: @item2.id)
    create(:item_order, order_id: @order3.id, item_id: @item1.id)
end
