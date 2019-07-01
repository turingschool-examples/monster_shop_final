class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart

  def cart
    @cart ||= Cart.new(session[:cart])
  end
end
