# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all
Review.destroy_all

User.create!(name: 'Admin', address: '123 Who Cares Ln', city: 'Denver', state: 'CO', zip: '12345', email: 'admin@admin.com', password: 'admin', role: 2)
User.create!(name: 'Default', address: '789 Hello St', city: 'Denver', state: 'CO', zip: '12345', email: 'default@default.com', password: 'default', role: 0)

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.users.create!(name: 'Merchant Employee', address: '456 Blah Blah Blvd', city: 'Denver', state: 'CO', zip: '12345', email: 'merchant@merchant.com', password: 'merchant')

megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Clothes', description: "Clothes!", price: 20, image: 'https://upload.wikimedia.org/wikipedia/commons/b/b0/MTB_over_the_bar_crash.jpg', active: true, inventory: 10 )
