class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    current_user.bookmarks.find_or_create_by!(review: @review)

    @bookmarked_reviews = current_user.bookmarked_reviews
                                     .includes(:user, :book, :image_tag)
                                     .order(created_at: :desc)

    @bookmark_count = Bookmark.where(user_id: current_user.id).count                                 

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    current_user.bookmarks.find_by!(review: @review).destroy!

    @bookmarked_reviews = current_user.bookmarked_reviews
                                       .includes(:user, :book, :image_tag)
                                       .order(created_at: :desc)

    @bookmark_count = Bookmark.where(user_id: current_user.id).count

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:review_public_id])
  end
end
