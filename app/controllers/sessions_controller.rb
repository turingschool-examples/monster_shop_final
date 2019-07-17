class SessionsController < ApplicationController
  def new
  end

  def logout
    redirect_to root_path
  end
end
