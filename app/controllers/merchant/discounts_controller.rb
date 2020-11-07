class Merchant::DiscountsController < Merchant::BaseController
  def index
    @user = User.find(session[:user_id])
    @merchant = Merchant.find(@user.merchant_id)
  end

  def new;end

  def create
    @user = User.find(session[:user_id])
    @merchant = Merchant.find(@user.merchant_id)
    @discount = @merchant.discounts.create(discount_params)
    if @discount.save
      flash[:success] = "Discount #{@discount.id} was added."
      redirect_to '/merchant/discounts'
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:quantity, :amount, :merchant_id)
  end
end