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

    # ▼ ネタバレ絞り込み
    if params[:spoiler].present?
      case params[:spoiler]
      when "1"
        @reviews = @reviews.where(is_spoiler: true)
      when "0"
        @reviews = @reviews.where(is_spoiler: false)
      end
    end

    # ▼ 並び順
    @reviews = @reviews.order(created_at: :desc)
  end

  def show
    @same_book_reviews =
      Review.same_book(@review)
            .includes(:user, :book, :image_tag)
            .limit(4)

    session[:review_return_to] =
      if request.referer&.include?(profile_path)
        profile_path
      else
        reviews_path
      end
  end

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
      # ★ エラー時に book が消えないように再生成
      @review.build_book if @review.book.nil?

      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    rp = review_params.deep_dup
    book_attrs = rp[:book_attributes] || {}

    if book_attrs[:remove_cover] == "1"
      @review.book.cover.purge if @review.book.cover.attached?
    end

    if book_attrs[:remove_cover_url] == "1"
      book_attrs[:cover_url] = nil
    end

    if @review.update(rp)
      redirect_to @review, notice: "レビューを更新しました。"
    else

      @review.assign_attributes(rp)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy

    redirect_to session.delete(:review_return_to) || reviews_path,
                notice: "レビューを削除しました。"
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:public_id])
  end

  def require_owner
    unless @review.user_id == current_user.id
      redirect_to review_path(@review), alert: "他のユーザーのレビューは編集できません。"
    end
  end

  def review_params
    params.require(:review).permit(
      :content,
      :is_spoiler,
      :image_tag_id,
      book_attributes: %i[
        id
        title
        author
        publisher
        published_on
        isbn
        description
        google_books_id
        cover_url
        cover
        remove_cover
        remove_cover_url
      ]
    )
  end

  def normalize_query(query)
    query.tr("　", " ").strip
  end
end
