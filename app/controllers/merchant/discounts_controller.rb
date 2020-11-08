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

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path
    else
      flash.now[:errors] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to merchant_discounts_path
  end

  private
  def discount_params
    params.require(:discount).permit(:name, :discount, :items_required)
  end

end
