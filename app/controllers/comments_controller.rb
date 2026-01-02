class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :set_comment, only: :destroy
  before_action :authorize_comment, only: :destroy

  def create
    @comment = @review.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      @review.reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to review_path(@review), notice: 'コメントを投稿しました' }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            'comment-form', 
            partial: 'comments/form', 
            locals: { review: @review, comment: @comment }
          )
        }
        format.html { 
          @comments = @review.comments.includes(:user).order(created_at: :desc)
          flash.now[:alert] = 'コメントの投稿に失敗しました'
          render 'reviews/show', status: :unprocessable_entity 
        }
      end
    end
  end

  def destroy
    @comment.destroy!
    @review.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to review_path(@review), notice: 'コメントを削除しました', status: :see_other }
    end
  end

  private

  def set_review
    @review = Review.find_by!(public_id: params[:review_public_id])
  end

  def set_comment
    @comment = @review.comments.find(params[:id])
  end

  def authorize_comment
    return if @comment.user == current_user

    respond_to do |format|
      format.turbo_stream { head :forbidden }
      format.html { redirect_to review_path(@review), alert: 'コメントを削除できませんでした', status: :see_other }
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
