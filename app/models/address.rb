class Address < ApplicationRecord

  has_many :user_addresses
  has_many :users, through: :user_addresses

  validates_presence_of :street_address,
                        :city,
                        :state,
                        :zip

  enum address_type: ['home', 'work']
end
