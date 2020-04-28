class Profile::BaseController < ApplicationController
  before_action :require_user
  before_action :exclude_admin
end
