class Registration
  include ActiveModel::Model

  attr_accessor :name,
                :address,
                :city,
                :state,
                :zip,
                :email,
                :password,
                :password_confirmation

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      user = User.create!(name: name, email: email, password: password)
      user.address.create!(address: address, city: city, state: state, zip: zip)
    end

    true
  end
end
