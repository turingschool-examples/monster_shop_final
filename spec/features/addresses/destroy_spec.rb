# require 'rails_helper'
#
# RSpec.describe 'Delete an Address' do
#   describe 'As a User' do
#     before :each do
#       @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
#       @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
#       @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
#       @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
#       @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
#       @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
#       @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
#       @user_address = @user.addresses.create!(street_address: '123 user lives here', city: 'Denver', state: 'CO', zip: 80301)
#
#       @order_1 = @user.orders.create!(status: "packaged", address_id: @user_address.id)
#       @order_2 = @user.orders.create!(status: "pending", address_id: @user_address.id)
#       @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
#       @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2, fulfilled: true)
#       @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
#       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
#       end
#     end
#     it ' I can delete an address addresses' do
#       expect(current_path).to eq(profile_path)
#       save_and_open_page
#       click_on "Edit My Address"
#
#
#       # expect(current_path).to eq(user_addresses_path)
#
#       fill_in 'Street address', with: 'Edited Address'
#       fill_in 'City', with: 'Edited'
#       fill_in 'State', with: 'Edited'
#       fill_in 'Zip', with: 'Edited'
#
#       click_on 'Update Address'
#
#
#     end
#   end
# end
