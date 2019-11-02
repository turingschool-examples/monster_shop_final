class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders
  has_many :addresses

  validates_presence_of :name,
                        :email

  validates_uniqueness_of :email

  enum role: ['default', 'merchant_admin', 'admin']

    # Write Tests!
    # Find way to make private without disabling assign_address being called in address model

    #Verify this can go here.
    # Called in controllers/user/addresses_controller.rb Create method
    # Returns true if none of THIS User's Addresses' nicknames include the nickname (passed as an argument) that will be used to create the new Address.
    def nickname_uniq?(nickname)
      !addresses.pluck(:nickname).include?(nickname)
    end

    def my_address
      addresses.find(self.default_address) if default_address != nil
    end

    def assign_address(address_id)
      self.default_address = address_id
    end
end
