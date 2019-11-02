# frozen_string_literal: true

class Merchant::BaseController < ApplicationController
  before_action :require_merchant
end
