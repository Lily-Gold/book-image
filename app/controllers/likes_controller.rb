class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    current_user.likes.find_or_create_by!(review: @review)
    redirect_back(fallback_location: reviews_path)
  end

  def destroy
    like = current_user.likes.find_by(review: @review)
    like&.destroy
    redirect_back(fallback_location: reviews_path)
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:review_public_id])
  end
end
