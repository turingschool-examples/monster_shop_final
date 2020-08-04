class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = current_user.merchant.discounts.new
  end

  def create
    merchant = params[:discount][:merchant_id]
    percent = params[:discount][:percent]
    quantity = params[:discount][:quantity_required]
    if Discount.where("percent = ? and quantity_required = ? and merchant_id = ?", percent, quantity, merchant).empty?
      Discount.create(percent: percent, quantity_required: quantity, merchant_id: merchant)
      flash[:success] = "New discount created."
      redirect_to "/merchant/discounts"
    else
      flash[:error] = "This discount already exists for your shop."
      redirect_to "/merchant/discounts"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    merchant = params[:discount][:merchant_id]
    percent = params[:discount][:percent]
    quantity = params[:discount][:quantity_required]
    if Discount.where("percent = ? and quantity_required = ? and merchant_id = ?", percent, quantity, merchant).empty?
      discount.update(percent: percent, quantity_required: quantity)
      flash[:success] = "Discount #{discount.id} has been successfully updated."
      redirect_to "/merchant/discounts"
    else
      flash[:error] = "This discount already exists for your shop, please try again."
      render :edit
    end
  end
end
