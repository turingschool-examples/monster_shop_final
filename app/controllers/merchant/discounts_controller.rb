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
	@discount = @merchant.discounts.new(permitted_discount_params)
  	if @discount.save
  		flash[:notice] = 'You just made a new discount!'
  		redirect_to '/merchant/discounts'
  	else
  		flash[:notice] = 'Failed to create new discount, try again!'
  		redirect_to '/merchant/discounts/new'
   end
 end

 private
 
 def permitted_discount_params
    params.permit(:title, :information, :lowest_amount, :highest_amount, :percent_off)
 end

end
