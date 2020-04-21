FactoryBot.define do
  factory :regular_user, class: User do
    name      { Faker::TvShows::BreakingBad.character }
    address   { Faker::Address.street_address }
    city      { Faker::Address.city }
    state     { Faker::Address.state }
    zip       { "11111" }
    email     { Faker::Internet.email }
    password  { "password123" }
    role      { 0 }
    merchant_id { nil }
  end
end
