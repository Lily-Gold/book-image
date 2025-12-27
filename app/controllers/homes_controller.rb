class HomesController < ApplicationController
  def index
    @top_reviews = Review
      .left_joins(:likes)
      .group(:id)
      .order(Arel.sql("COUNT(likes.id) DESC, reviews.created_at DESC"))
      .limit(3)
  end
end
