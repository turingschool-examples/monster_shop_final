class Address < ApplicationRecord

  belongs_to :user
  # , inverse_of: :addresses
  has_many :orders

  

  validates_presence_of :street_address,
                        :city,
                        :state,
                        :zip

  validates_associated :user

  # enum address_type: ['home', 'work', 'other']
end

#   def new
#     # @address = Address.new
#   end
# end
  #
  # def edit
  #   @address = Address.find(params[:id])
  # end
  #
  # def udpate
  #   @address = current_user.addresses.build(user_params)
  #
  #   if @address.save
  #     flash[:success] = "A new address has been submitted!"
  #     redirect_to @address
  #   else
  #     render 'new'
  #   end
  # end
  #
  # private
  #
  # def user_params
  #  params.require(:address).permit(:street_address, :city, :state, user_attributes: [:name,:email])
  # end
