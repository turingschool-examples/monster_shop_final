class Address < ApplicationRecord
  belongs_to :user
  # has_many :orders, through: :users
  has_many :orders

  validates_presence_of :address,
                        :city,
                        :state,
                        :zip,
                        :nickname

  validates_uniqueness_of :nickname, conditions: -> { where(user_id: self.user_id) }, confirmation: { case_sensitive: false }
end
