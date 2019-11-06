class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders
  has_many :addresses, inverse_of: :user, dependent: :destroy
  accepts_nested_attributes_for :addresses

  validates_presence_of :name,
                        :email
  validates_uniqueness_of :email

  enum role: ['default', 'merchant_admin', 'admin']

    # Called in controllers/user/addresses_controller.rb Create method
    # Returns true if none of THIS User's Addresses' nicknames include the nickname (passed as an argument) that will be used to create the new Address.
  def nickname_uniq?(nickname)
    !addresses.pluck(:nickname).include?(nickname)
  end

    # Searches child Addresses for the Address who's :id matches the User's default_address:address.id
  def my_address
    addresses.find(default_address) if default_address != nil
  end

  def current_address?(address_id)
    default_address == address_id
  end

  def assign_address(address_id)
    self.default_address = address_id
    self.save
  end
  # Changes the current User's default_address column = to the address_id passed as an argument.
  # Whenever the number of User Addresses == 1, either on creation of the 1st address. Or deletion of the 2nd existing address.
end
