class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @reviews = current_user.reviews.order(created_at: :desc)
    @bookmarked_reviews = current_user.bookmarked_reviews
                                     .includes(:user, :book, :image_tag)
                                     .order("bookmarks.created_at DESC")
  end
end
