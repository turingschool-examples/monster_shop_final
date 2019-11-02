class User < ApplicationRecord
  has_secure_password

  belongs_to :merchant, optional: true
  has_many :orders
  has_many :addresses # :inverse_of could be called here (and in address model) to gain access to each others private methods. 

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

      # Searches child Addresses for the Address who's :id matches the User's default_address:address.id  
    def my_address
      addresses.find(self.default_address) if default_address != nil
    end

      # Changes the current User's default_address column = to the address_id passed as an argument. Problem: Should be private yet *still accessible from the address model* **or find a better way to assign the default :id
      # Whenever the number of User Addresses == 1, either on creation of the 1st address. Or deletion of the 2nd existing address. 
    def assign_address(address_id)
      self.default_address = address_id
    end
end
