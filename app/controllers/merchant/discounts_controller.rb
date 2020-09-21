class Merchant::DiscountsController < Merchant::BaseController

    def new
        merchant = Merchant.find(current_user.merchant_id)
        @discount = merchant.discounts.new
    end

    def create

        merchant = Merchant.find(current_user.merchant_id)
        @discount = merchant.discounts.new(discount_params)
        if @discount.save
          redirect_to "/merchant"
        else
          flash[:error] = @discount.errors.full_messages.to_sentence
          render :new
        end
    end




  private

  def discount_params
    params.require(:discount).permit(:threshold_quantity, :discount_percentage)
  end

end