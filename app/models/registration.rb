class Registration
  include ActiveModel::Model

  attr_accessor :name,
                :address,
                :city,
                :state,
                :zip,
                :email,
                :password,
                :password_confirmation,
                :user

  validates_presence_of :name,
                        :email,
                        :password,
                        :address,
                        :city,
                        :state,
                        :zip

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      @user = User.create(name: name, email: email, password: password)
      errors.add(:email, @user.errors.messages[:email].first)
      if @user.valid?
        @user.addresses.create(address: address, city: city, state: state, zip: zip)
      end
    end
  end
end
