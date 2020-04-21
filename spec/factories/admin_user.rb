FactoryBot.define do
  factory :admin_user, class: User do
    name      { Faker::Name.name }
    address   { Faker::Address.street_address }
    city      { Faker::Address.city }
    state     { Faker::Address.state }
    zip       { "11111" }
    email     { Faker::Internet.email }
    password  { "password123" }
    role      { 2 }
  end
end
