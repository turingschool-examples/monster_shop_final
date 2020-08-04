# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
m_user = megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
m_user.merchant.discounts.create(percentage: 5, item_amount: 5, description: 'Five percent off of five items or more!')
m_user.merchant.discounts.create(percentage: 20, item_amount: 10, description: 'Fifteen percent off of ten items or more!')
m_user.merchant.discounts.create(percentage: 15, item_amount: 9, description: 'Fifteen percent off of nine items or more!')
megan.items.create!(name: 'Candle', description: "I'll light up your life!", price: 5, image: 'https://cf.ltkcdn.net/candles/images/orig/257384-1600x1030-white-candle-magic-spells.jpg', active: true, inventory: 30 )
megan.items.create!(name: 'Dish Towel', description: "I'll clean it up!", price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSKTzwz1piuGJO5B0aUlunlY9LCM0wVP1wkag&usqp=CAU', active: true, inventory: 100 )
brian.items.create!(name: 'Everything Bagel', description: "I've got anything you want!", price: 12, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQos5CbFANK1ZNGcqT-DycLcspuLqxqfRLRNE-HEYkqYKy88NOu8HjTeiGuiFyq5c7kxEIsmuX6&usqp=CAc', active: true, inventory: 100 )
