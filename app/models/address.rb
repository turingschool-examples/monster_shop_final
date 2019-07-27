class Address < ApplicationRecord

  belongs_to :user

  validates_presence_of :street_address,
                        :city,
                        :state,
                        :zip

  enum address_type: ['home', 'work']
end
