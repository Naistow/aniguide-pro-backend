class ReviewsController < ApplicationController
  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_back fallback_location: root_path, notice: "Ваш отзыв добавлен!"
    else
      redirect_back fallback_location: root_path, alert: "Ошибка при добавлении отзыва."
    end
  end

  def destroy
    review = Review.find(params[:id])
    if review.user == current_user || current_user.admin?
      review.destroy
      redirect_back fallback_location: root_path, notice: "Отзыв удален."
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :franchise_id)
  end
end