class Coupon < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true

  validates_presence_of :percentage

  belongs_to :merchant, optional: true
end
