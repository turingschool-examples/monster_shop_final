class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :address, :city, :state, :zip, :nickname
end
