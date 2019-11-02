# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.by_status
  end
end
