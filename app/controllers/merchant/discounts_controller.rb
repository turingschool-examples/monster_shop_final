class Merchant::DiscountsController < Merchant::BaseController

    def new
        merchant = Merchant.find(current_user.merchant_id)
        @discount = merchant.discounts.new
    end

    def create
        merchant = Merchant.find(current_user.merchant_id)
        @discount = merchant.discounts.new(discount_params)
        if @discount.save
            flash[:success] = "Discount Added"
            redirect_to "/merchant"
        else
          flash[:error] = @discount.errors.full_messages.to_sentence
          render :new
        end
    end

    def edit
        @discount = Discount.find(params[:id])
    end

    def update
        @discount = Discount.find(params[:id])
        if @discount.update(threshold_quantity: params[:discount][:threshold_quantity], discount_percentage: params[:discount][:discount_percentage])
            # current_user.merchant.discounts.reload
            flash[:success] = "Discount Updated!"
            redirect_to "/merchant"
        else
          flash[:error] = @discount.errors.full_messages.to_sentence
          render :edit
        end
    end

    def destroy
      discount = Discount.find(params[:id])
      discount.destroy!
      # current_user.merchant.discounts.reload
      flash[:success] = "Discount Removed!"
      redirect_to "/merchant"
    end

  private

  def discount_params
    params.require(:discount).permit(:threshold_quantity, :discount_percentage)
  end

end