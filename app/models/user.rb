# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :email

  validates_uniqueness_of :email

  enum role: %w[default merchant_admin admin]
end
