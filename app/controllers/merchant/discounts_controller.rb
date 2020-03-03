class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:discount_id])
  end

  def new
  end

  def create
  	@merchant = current_user.merchant
  	@discount = @merchant.discounts.new(private_discount_params)
  	if @discount.save
  		flash[:notice] = 'You just made a new discount!'
  		redirect_to '/merchant/discounts'
  	else
  		flash[:notice] = 'Failed to create new discount, try again!'
  		redirect_to '/merchant/discounts/new'
   end
 end

 def edit
   @discount = Discount.find(params[:discount_id])
 end

 def update
   discount = Discount.find(params[:discount_id])
    if discount.update(private_discount_params)
      flash[:notice] = "Your discount changes have been saved."
      redirect_to "/merchant/discounts/#{discount.id}"
    else
      flash[:notice] = "Your discount changes have not been saved."
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

 private

 def private_discount_params
    params.permit(:title, :information, :lowest_amount, :highest_amount, :percent_off)
 end

end
