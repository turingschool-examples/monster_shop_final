class ReviewsController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find(params[:item_id])
    review = @item.reviews.new(review_params)
    if review.save
      redirect_to item_path(@item)
    else
      generate_flash(review)
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to item_path(@review.item)
  end

  private

  def review_params
    params.permit(:title, :description, :rating)
  end

  def generate_flash(review)
    review.errors.messages.each do |validation, message|
      flash[:notice] = "#{validation}: #{message}"
    end
  end
end
