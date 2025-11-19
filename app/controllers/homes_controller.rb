class HomesController < ApplicationController
  def index
    @first_reviews = Review.order(created_at: :asc).limit(3)
  end
end
