# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
#
#
watchmen = Merchant.create!(name: 'Watchmen, Inc.', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
discovery = Merchant.create!(name: 'Discovery Watches', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
watchmen.items.create!(name: 'Frogman GPS Watch', description: "Ideal for scuba diving and outdoor adventures", price: 740, image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.deeperblue.com%2Fwp-content%2Fuploads%2F2017%2F02%2FA_G-Shock.jpg&f=1&nofb=1', active: true, inventory: 10 )
watchmen.items.create!(name: 'Protrek', description: "A climbing watch", price: 250, image: 'https://i02.hsncdn.com/is/image/HomeShoppingNetwork/prodfull/casio-pro-trek-mens-triple-sensor-atomic-solar-watch-ti-d-2019110511250085~9342734w.jpg', active: true, inventory: 12 )
watchmen.items.create!(name: 'Fishmaster', description: "The master of the fish", price: 40, image: 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F1.bp.blogspot.com%2F-z96uB1dKjSI%2FUKunpYCnCAI%2FAAAAAAAAAEw%2FB0PK0yObHD8%2Fs1600%2FCasio%2BMen%27s%2BPAS400B-5V.jpg&f=1&nofb=1', active: true, inventory: 2 )
watchmen.items.create!(name: 'Illuminator', description: "Lights up in the dark!", price: 23, image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.downunderwatches.com%2Fwp-content%2Fuploads%2F2017%2F11%2FAE-1000W-2AV.jpg&f=1&nofb=1', active: true, inventory: 30 )
discovery.items.create!(name: 'Illuminator', description: "Lights up in the dark!", price: 23, image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.downunderwatches.com%2Fwp-content%2Fuploads%2F2017%2F11%2FAE-1000W-2AV.jpg&f=1&nofb=1', active: true, inventory: 10 )
discovery.items.create!(name: 'Poptone', description: "Lots of fun!", price: 50, image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.M7VSe-rvlPXHvdwX8D8o8AHaHa%26pid%3DApi&f=1', active: true, inventory: 40 )
jess = User.create!(name: "Jess E", address: "412 E 945th St", city: "Gotham City", state: "NY", zip: 10612, email: "lasers_are_cool@turing.io", password: "foobar", role: 1, merchant_id: watchmen.id)
naf = User.create!(name: "Naf S", address: "93 W 123rd St", city: "Gotham City", state: "NY", zip: 10612, email: "nafnaf@naf.naf", password: "foobar", role: 0)
