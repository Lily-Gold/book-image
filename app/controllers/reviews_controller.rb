class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = Review.includes(:book, :user).order(created_at: :desc)
  end

  def show
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

  def edit
  end

  def update
    # ★ ここが超重要：remove_cover を見て削除する
    if params[:review][:book_attributes][:remove_cover] == "1"
      @review.book.cover.purge if @review.book.cover.attached?
    end

    if @review.update(review_params)
      redirect_to @review, notice: "レビューを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_path, notice: "レビューを削除しました。"
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    rp = params.require(:review).permit(
      :content,
      :is_spoiler,
      :image_tag_id,
      book_attributes: [
        :id,
        :title, :author, :publisher, :published_on,
        :isbn, :description,
        :cover,
        :remove_cover
      ]
    )

    if rp[:book_attributes][:cover].blank?
      rp[:book_attributes].delete(:cover)
    end

    rp
  end
end
