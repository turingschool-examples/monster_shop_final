class Address < ApplicationRecord
  belongs_to :user, inverse_of: :addresses
  has_many :orders

  validates :user, :presence => true
  validates_presence_of :address,
                        :city,
                        :state,
                        :zip,
                        :nickname

  before_validation :default_nickname, on: :create
  after_validation :normalize_nickname, on: [ :create, :update ]
  after_create :assign_default_address

    # Is there a way to put this default value into the schema with the same validation? Or is here better anyways
    def default_nickname
      # First Conditional to bypass models/address_spec errors
      # Second Conditional to specify: when a nickname isn't provided
      if self.user_id != nil && self.nickname == nil
          self.nickname = 'home' if self.user.addresses.empty?
          # Conditional ensures this method
          # only triggers for the first address a User creates.
      end
    end

    def normalize_nickname
      self.nickname = self.nickname.downcase.titleize if self.nickname != nil
    end

    def assign_default_address
      self.user.assign_address(self.id) if self.user.addresses.size <= 1
      # Conditional ensures this method only triggers when parent User has a single address
    end
end

#Cant get it to only validate nicknames belonging to the same user (having the same user_id value). Need to figure out a way to *reference the user_id of the row being created* and compare it to other rows.
