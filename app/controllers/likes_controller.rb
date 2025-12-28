class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    current_user.likes.find_or_create_by!(review: @review)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    current_user.likes.find_by!(review: @review).destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:review_public_id])
  end
end
