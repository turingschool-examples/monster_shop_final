class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = User.find(session[:user_id]).merchant
    @discounts = @merchant.discounts
  end

  def new
    @merchant = User.find(session[:user_id]).merchant
    @discount = @merchant.discounts.new
  end

  def create
    @merchant = User.find(session[:user_id]).merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path
    else
      flash.now[:errors] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private
  def discount_params
    params.require(:discount).permit(:name, :discount, :items_required)
  end

end
