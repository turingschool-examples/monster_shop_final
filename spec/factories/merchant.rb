FactoryBot.define do
  factory :merchant, class: Merchant do
    name     { Faker::Games::Pokemon.name }
    address  { Faker::Address.street_address }
    city     { Faker::Address.city }
    state    { Faker::Address.state }
    zip      { "12345" }
  end
end
