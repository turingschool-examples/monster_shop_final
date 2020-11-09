placeholder_image = "https://www.webfx.com/blog/images/cdn.designinstruct.com/files/582-how-to-image-placeholders/generic-image-placeholder.png"


FactoryBot.define do
  factory :item do
    merchant
    sequence(:name) { |n| "Item #{n}" }
    description { "What a cool item!" }
    price { 100.00 }
    inventory { 12 }
    image { placeholder_image }
    active { true }
  end

  factory :merchant do
    sequence(:name) { |n| "Merchant #{n}" }
    address { "22 Baker St" }
    city { "London" }
    state { "TX" }
    zip { 10000 }
    enabled { true }
  end

  factory :order do
    user
    status { 0 }
  end

  factory :review do
    item
    sequence(:title) { |n| "Review #{n}"}
    description { "This was awesome!" }
    rating { 5 }
  end

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    address { "Cool Street" }
    city { "Rubyville" }
    state { "CO" }
    zip { 10000 }
    sequence(:email) { |n| "user#{n}@email.com"}
    password { "password" }
    role { 0 }
  end

  factory :bulk_discount, aliases: [:discount] do
    merchant
    bulk_quantity { 20 }
    percentage_discount { 5 }
  end
end
