class AddressesController < ApplicationController
  # before_action :require_user, only: :show
  # before_action :exclude_admin, only: :show

  def index
    binding.pry
    @addreses = Address.all

  end
end
