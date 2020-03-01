OrderItem.destroy_all
ItemDiscount.destroy_all
Order.destroy_all
Item.destroy_all
Discount.destroy_all
Review.destroy_all
User.destroy_all
Merchant.destroy_all

#merchants
megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

#items
item_1 = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
item_2 = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
item_3 = megan.items.create!(name: 'Crepe', description: "I'm a Crepe!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
item_4 = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

#users
ben = megan.users.create!(name: "Ben Fox", address: "2475 Field St", city: "Lakewood", state: "CO", zip: "80215", email: "benfox1216@gmail.com", password: "password")

#discounts
discount_1 = megan.discounts.create!(amount: 20, num_items: 5)
discount_2 = megan.discounts.create!(amount: 25, num_items: 10)
discount_3 = megan.discounts.create!(amount: 30, num_items: 20)

#item_discounts
discount_1.item_discounts.create!(item_id: item_1.id, amount: discount_1.amount, num_items: discount_1.num_items)
discount_2.item_discounts.create!(item_id: item_1.id, amount: discount_2.amount, num_items: discount_2.num_items)
discount_2.item_discounts.create!(item_id: item_2.id, amount: discount_2.amount, num_items: discount_2.num_items)
binding.pry