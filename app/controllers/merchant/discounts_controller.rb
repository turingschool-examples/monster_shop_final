class Merchant::DiscountsController < Merchant::BaseController
  def index
    @user = User.find(session[:user_id])
    @merchant = Merchant.find(@user.merchant_id)
  end

  def new;end

  def create
    user = User.find(session[:user_id])
    merchant = Merchant.find(user.merchant_id)
    discount = merchant.discounts.create(discount_params)
    if discount.save
      flash[:success] = "Discount #{discount.id} was added."
      redirect_to '/merchant/discounts'
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:discount_id])
  end 

  def update
    discount = Discount.find(params[:discount_id])
    discount.update(discount_params)
    if discount.save
      flash[:success] = "Discount #{discount.id} was updated."
      redirect_to '/merchant/discounts'
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:discount_id])
    discount.destroy
    flash[:success] = "#{discount.amount}% off #{discount.quantity} items was deleted."
    redirect_to '/merchant/discounts'
  end

  private

  def discount_params
    params.permit(:quantity, :amount, :merchant_id)
  end
end