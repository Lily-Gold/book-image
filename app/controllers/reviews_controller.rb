class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_review, only: %i[show edit update destroy]
  before_action :require_owner, only: %i[edit update destroy]

  def index
    @reviews = Review.includes(:book, :user, :image_tag)

    # ▼ キーワード検索（タイトル・著者・ISBN）
    if params[:q].present?
      keywords = normalize_query(params[:q]).split(" ")

      keywords.each do |word|
        @reviews = @reviews.joins(:book).where(
          "books.title ILIKE :kw
           OR books.author ILIKE :kw
           OR books.isbn = :isbn",
          kw: "%#{word}%",
          isbn: word
        )
      end
    end

    # ▼ 印象カラー絞り込み
    @reviews = @reviews.where(image_tag_id: params[:color]) if params[:color].present?

    # ▼ 並び順
    @reviews = @reviews.order(created_at: :desc)
  end

  def show; end

  def new
    @review = Review.new
    @review.build_book
  end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      flash[:notice] = "レビューを投稿しました。"
      redirect_to reviews_path(just_posted: true, id: @review.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params.dig(:review, :book_attributes, :remove_cover) == "1"
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

  def require_owner
    unless @review.user_id == current_user.id
      redirect_to review_path(@review), alert: "他のユーザーのレビューは編集できません。"
    end
  end

  def review_params
    rp = params.require(:review).permit(
      :content,
      :is_spoiler,
      :image_tag_id,
      book_attributes: %i[
        id title author publisher published_on
        isbn description cover remove_cover
      ]
    )

    rp[:book_attributes].delete(:cover) if rp[:book_attributes][:cover].blank?
    rp
  end
end
