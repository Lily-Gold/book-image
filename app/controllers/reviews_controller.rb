class ReviewsController < ApplicationController
  def index
    @reviews = Review.includes(:book, :user).order(created_at: :desc)
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
    @review.build_book
  end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      redirect_to reviews_path, notice: "レビューを投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :content,
      :is_spoiler,
      :image_tag_id,
      book_attributes: [ :title, :author, :publisher, :published_on, :isbn, :description, :cover ]
    )
  end
end
