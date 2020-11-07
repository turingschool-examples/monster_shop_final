class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new

  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to '/merchant/discounts'
    else
      flash.now[:alert] = 'You must fill out all fields to create this discount. Try again'
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:success] = 'You successfully updated your discount!'
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      flash.now[:alert] = 'You cannot leave a field blank. Please fully fill out the form'
      render :edit
    end
  end

  def destroy
    merchant = current_user.merchant
    discount = Discount.find(params[:id])
    # merchant.discounts.destroy(discount.id)
    if discount.destroy
      flash[:success] = 'You have successfully deleted this discount'
      redirect_to '/merchant/discounts'
    end
  end

  private
  def discount_params
    params.permit(:description, :quantity, :percent)
  end
end
