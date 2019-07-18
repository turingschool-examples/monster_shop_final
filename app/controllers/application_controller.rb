class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart,
                :current_user,
                :current_merchant_user?,
                :current_admin?

  def cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant_user?
    current_user && current_user.merchant_id
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def require_user
    render file: 'public/404', status: 404 unless current_user
  end

  def require_merchant
    render file: 'public/404', status: 404 unless current_merchant_user?
  end

  def require_admin
    render file: 'public/404', status: 404 unless current_admin?
  end

  def exclude_admin
    render file: 'public/404', status: 404 if current_admin?
  end

  def generate_flash(resource)
    resource.errors.messages.each do |validation, message|
      flash[validation] = "#{validation}: #{message}"
    end
  end
end
