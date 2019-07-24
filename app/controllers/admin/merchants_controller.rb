class Admin::MerchantsController < Admin::BaseController
  def show
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(enabled: !merchant.enabled)
    if merchant.enabled?
      flash[:notice] = "#{merchant.name} has been enabled"
    else
      flash[:notice] = "#{merchant.name} has been disabled"
    end
    redirect_to merchants_path
  end
end
