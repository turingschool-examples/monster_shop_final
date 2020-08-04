# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: megan.id)

user = User.create!(name: 'Alex Kio', address: '1204 NE 10th Ave.', city: 'Gainesville', state: 'FL', zip: 32601, email: 'user@hotmail.com', password: 'user')

ogre = megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
giant = megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
fig = megan.items.create!(name: 'Fig Jam', description: "I'm delicious!", price: 5, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 22 )

hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

order_1 = Order.create!(user_id: user.id)

OrderItem.create!(order_id: order_1.id, item_id: fig.id, price: fig.price, quantity: 10, fulfilled: false)
OrderItem.create!(order_id: order_1.id, item_id: ogre.id, price: ogre.price, quantity: 2, fulfilled: false)
