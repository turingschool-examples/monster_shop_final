FactoryBot.define do
  factory :item do
    sequence(:name) {|n| "Item Name: #{n}" }
    sequence(:description) {|n| "Item Description: #{n}"}
    sequence(:price) {|n| (n + 1) * 1.05 }
    image {"http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg"}
    sequence(:inventory) {rand(1..100)}
    active {true}
    merchant
  end

  factory :merchant do
    sequence(:name) {|n| "Merchant Name: #{n}" }
    sequence(:address) {|n| "Merchant Address: #{n}"}
    sequence(:city) {|n| "City: #{n}"}
    sequence(:state) {|n| "State: #{n}"}
    sequence(:zip) {|n| "Zip: #{n}"}
  end

  factory :user do
    sequence(:name) {|n| "User Name: #{n}" }
    sequence(:address) {|n| "User Address: #{n}"}
    sequence(:city) {|n| "City: #{n}"}
    sequence(:state) {|n| "State: #{n}"}
    sequence(:zip) {|n| "Zip: #{n}"}
    sequence(:email) {|n| "email#{n}@email.com"}
    sequence(:password) {|n| "123whollysmokes"}
    sequence(:password_confirmation) {|n| "123whollysmokes"}
  end

  factory :order_item do
    order
    item
    price {item.price}
    quantity {rand(1..5)}
  end

  factory :order do
    user
  end
end
