class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user.merchant
  end
end
