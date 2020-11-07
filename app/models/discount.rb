class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  validates_presence_of :description
  validates_presence_of :quantity
  validates_presence_of :percent
  validates_presence_of :enable
end
